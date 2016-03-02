import '../devices.dart';

class LT201 extends MamacDevice {
  static const String type = 'LT201';
  static const String xmlFile = 'lt201.xml';

  String get deviceType => type;
  String get fileName => xmlFile;

  LT201(DeviceParams deviceParams)
      : super(deviceParams);
}
