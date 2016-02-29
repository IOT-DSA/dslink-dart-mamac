import 'dart:async';
import 'dart:convert' show UTF8;
import 'dart:collection' show Queue;
import 'dart:io';

import 'package:dslink/utils.dart' show logger;

class MamacClient {
  static const int maxRequests = 3;
  static MamacClient _cache;

  HttpClient _client;
  Queue<PendingRequest> _queue;
  int _numRequests = 0;

  factory MamacClient() => _cache ??= new MamacClient._();

  MamacClient._() {
    _client = new HttpClient();
    _queue = new Queue<PendingRequest>();
  }

  Future get(Uri uri) {
    var pr = new PendingRequest(uri, RequestType.get);
    _queue.add(pr);
    _sendRequests();
    return pr.done;
  }

  Future post(Uri uri) {
    var pr = new PendingRequest(uri, RequestType.post);
    _queue.add(pr);
    _sendRequests();
    return pr.done;
  }

  Future _sendRequests() async {
    if (_numRequests >= maxRequests || _queue.isEmpty) return;

    _numRequests += 1;
    var pr = _queue.removeFirst();

    HttpClientRequest req;
    HttpClientResponse resp;
    String data;
    try {
      switch (pr.type) {
        case RequestType.get:
          req = await _client.getUrl(pr.uri);
          break;
        case RequestType.post:
          req = await _client.postUrl(pr.uri);
          break;
      }

      resp = await req.close();
      var statusCode = resp.statusCode;
      if (statusCode == 404) {
        throw new HttpException(
            "Cannot reach the specified endpoint ${pr.uri.path}");
      }

      data = await resp.transform(UTF8.decoder).join();
    } on HttpException catch (e) {
      logger.warning('Unable to connect to ${pr.uri}', e);
    } catch (e, s) {
      logger.warning('Failed to get data.', e);
    }

    if (pr.type == RequestType.post) {
      print('Response Status: ${resp.statusCode}');
      print('Post Results: $data');
    }

    pr._completer.complete(data);
    _numRequests -= 1;
    _sendRequests();
  }
}

enum RequestType { get, post }

class PendingRequest {
  Uri uri;
  Completer<String> _completer;
  Future<String> get done => _completer.future;
  RequestType type;

  PendingRequest(this.uri, this.type) {
    _completer = new Completer<String>();
  }
}
