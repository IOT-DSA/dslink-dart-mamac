import '../devices.dart';

class SM101 extends MamacDevice {
  static const String type = 'sm101';
  static const String xmlFile = 'sm101.xml';

  String get deviceType => type;
  String get fileName => xmlFile;

  // TODO: Verify for this device -- the xml and post document don't make sense
  SM101.fromParams(DeviceParams deviceParams)
      : super(deviceParams);
}
