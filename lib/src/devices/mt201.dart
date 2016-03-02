import '../mamac_device.dart';
import '../devices.dart';
import '../node_parser.dart';

class MT201 extends MamacDevice {
  static const String type = 'mt201';
  static const String xmlFile = 'mt201ext.xml';

  String get deviceType => type;
  String get fileName => xmlFile;

  MT201.fromParams(DeviceParams deviceParams)
      : super(deviceParams.address, deviceParams.refreshRate);
}
