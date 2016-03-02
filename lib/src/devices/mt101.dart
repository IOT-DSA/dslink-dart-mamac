import '../mamac_device.dart';
import '../devices.dart';
import '../node_parser.dart';

class MT101 extends MamacDevice {
  static const String type = 'mt101';
  static const String xmlFile = 'mt101ext.xml';

  String get deviceType => type;
  String get fileName => xmlFile;

  MT101.fromParams(DeviceParams deviceParams)
      : super(deviceParams.address, deviceParams.refreshRate);
}
