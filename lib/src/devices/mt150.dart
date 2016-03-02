import '../mamac_device.dart';
import '../devices.dart';
import '../node_parser.dart';

class MT150 extends MamacDevice {
  static const String type = 'mt150';
  static const String xmlFile = 'mt150ext.xml';

  String get deviceType => type;
  String get fileName => xmlFile;

  MT150.fromParams(DeviceParams deviceParams)
      : super(deviceParams.address, deviceParams.refreshRate);
}
