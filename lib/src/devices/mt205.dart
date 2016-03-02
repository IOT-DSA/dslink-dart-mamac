import '../devices.dart';

class MT205 extends MamacDevice {
  static const String type = 'mt205';
  static const String xmlFile = 'mt205ext.xml';

  String get deviceType => type;
  String get fileName => xmlFile;

  MT205(DeviceParams deviceParams)
      : super(deviceParams);
}
