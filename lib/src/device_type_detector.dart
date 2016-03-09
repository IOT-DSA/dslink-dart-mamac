import 'package:http/http.dart';
import 'dart:async';
import 'devices.dart';

class DeviceTypeDetector {
  Client client;
  static const String pageToCrawl = 'start.html';

  Future<String> findType(Uri deviceAddress) async {
    client = new Client();

    var response = await client.get('${deviceAddress.toString()}/$pageToCrawl');
    var content = response.body;

    for (var deviceType in deviceTypes) {
      if (content.contains(deviceType)) {
        return deviceType;
      }
    }

    client.close();
    throw new Exception('Cannot detect device type');
  }
}
