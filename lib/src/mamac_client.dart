library dslink.mamac.client;

import 'dart:async';
import 'dart:io';

import 'package:dslink/utils.dart' show logger;

class MamacClient {
  static const int maxRequests = 3;
  static MamacClient _cache;
  HttpClient _client;

  factory MamacClient() => _cache ??= new MamacClient._();

  MamacClient._() {
    _client = new HttpClient();
  }

  Future get(Uri uri) {
    // TODO
  }
}

class PendingRequest {
  Uri uri;
  Completer _completer;
  Future get done => _completer.future;

  PendingRequest(this.uri) {
    _completer = new Completer();
  }
}