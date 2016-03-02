import '../devices.dart';

class PC10180 extends MamacDevice {
  static const String type = 'pc10180';
  static const String xmlFile = 'pc10180.xml';

  String get deviceType => type;
  String get fileName => xmlFile;

  // TODO: Check for this device
  // The POST document doesn't fit with the xml file.
  PC10180.fromParams(DeviceParams deviceParams)
      : super(deviceParams);
}
