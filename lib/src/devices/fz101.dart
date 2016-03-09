import '../devices.dart';

class FZ101 extends MamacDevice {
  static const String type = 'fz101';
  static const String xmlFile = 'fz101.xml';

  String get deviceType => type;
  String get fileName => xmlFile;

  FZ101(DeviceParams deviceParams) : super(deviceParams);
}
