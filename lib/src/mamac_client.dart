library dslink.mamac.client;

import 'dart:async';
import 'dart:io';

import 'package:dslink/utils.dart' show logger;

class MamacClient {
  static MamacClient _cache;
  HttpClient _client;

  factory MamacClient() => _cache ??= new MamacClient._();

  MamacClient._() {
    _client = new HttpClient();
  }
}