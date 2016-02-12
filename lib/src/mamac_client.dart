library dslink.mamac.client;

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

  Future get(Uri uri) async {
    var pr = new PendingRequest(uri);
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
      req = await _client.getUrl(pr.uri);
      resp = await req.close();
      data = await resp.transform(UTF8.decoder).join();
    } on HttpException catch (e) {
      logger.warning('Unable to connect to ${pr.uri}', e);
    } catch (e, s) {
      logger.warning('Failed to get data.', e);
    }

    pr._completer.complete(data);
    _numRequests -= 1;
    _sendRequests();
  }
}

class PendingRequest {
  Uri uri;
  Completer<String> _completer;
  Future<String> get done => _completer.future;

  PendingRequest(this.uri) {
    _completer = new Completer<String>();
  }
}