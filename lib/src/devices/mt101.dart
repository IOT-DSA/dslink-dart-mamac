import '../devices.dart';

class MT101 extends MamacDevice {
  static const String type = 'mt101';
  static const String xmlFile = 'mt101ext.xml';

  String get deviceType => type;
  String get fileName => xmlFile;

  MT101(DeviceParams deviceParams) : super(deviceParams);
}
