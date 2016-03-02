import '../mamac_device.dart';
import '../devices.dart';
import '../node_parser.dart';

class CF201 extends MamacDevice {
  static const String type = 'cf201';
  static const String xmlFile = 'cf201.xml';

  String get deviceType => type;
  String get fileName => xmlFile;

  CF201.fromParams(DeviceParams deviceParams)
      : super(deviceParams.address, deviceParams.refreshRate);
}
