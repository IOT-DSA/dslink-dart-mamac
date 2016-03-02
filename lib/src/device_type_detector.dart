import 'package:http/http.dart';
import 'dart:async';
import 'devices.dart';

class DeviceTypeDetector {
  final Client client = new Client();
  static const String pageToCrawl = 'start.html';

  Future<String> findType(Uri deviceAddress) async {
    for (var deviceType in deviceTypes) {
      var response = await client.get('$deviceAddress/$pageToCrawl');
      var content = response.body;

      if (content.contains(deviceType)) {
        return deviceType;
      }
    }

    throw new Exception('Cannot detect device type');
  }
}
