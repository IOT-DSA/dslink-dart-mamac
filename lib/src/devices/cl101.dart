import '../devices.dart';

class CL101 extends MamacDevice {
  static const String type = 'cl101';
  static const String xmlFile = 'cl101.xml';

  String get deviceType => type;
  String get fileName => xmlFile;

  CL101.fromParams(DeviceParams deviceParams)
      : super(deviceParams);
}
