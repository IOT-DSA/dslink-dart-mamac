import '../devices.dart';

class CF201 extends MamacDevice {
  static const String type = 'cf201';
  static const String xmlFile = 'cf201.xml';

  String get deviceType => type;
  String get fileName => xmlFile;

  CF201.fromParams(DeviceParams deviceParams)
      : super(deviceParams);
}
