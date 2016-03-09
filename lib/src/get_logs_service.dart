import 'dart:async';
import 'package:http/http.dart';
import 'devices.dart';
import 'uri_parser.dart';

class GetLogsService {
  Client _client;

  Future<String> fetchCsvLogs(MamacDevice device, LogEntry logEntry) async {
    _client = new Client();

    var uri = parseAddress(device.deviceParams.address);
    uri = uri.replace(path: '/${logEntry.csvPath}');

    var response = await _client.get(uri);

    _client.close();

    return response.body;
  }
}
