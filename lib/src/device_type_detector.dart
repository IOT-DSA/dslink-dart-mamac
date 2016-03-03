import 'package:http/http.dart';
import 'dart:async';
import 'devices.dart';

class DeviceTypeDetector {
  Client client;
  static const String pageToCrawl = 'start.html';

  Future<String> findType(Uri deviceAddress) async {
    client = new Client();
    for (var deviceType in deviceTypes) {
      var response = await client.get('$deviceAddress/$pageToCrawl');
      var content = response.body;

      if (content.contains(deviceType)) {
        client.close();
        return deviceType;
      }
    }

    client.close();
    throw new Exception('Cannot detect device type');
  }
}
