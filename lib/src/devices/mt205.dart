import '../mamac_device.dart';
import '../devices.dart';
import '../node_parser.dart';

class MT205 extends MamacDevice {
  static const String type = 'mt205';
  static const String xmlFile = 'mt205ext.xml';

  String get deviceType => type;
  String get fileName => xmlFile;

  MT205.fromParams(DeviceParams deviceParams)
      : super(deviceParams.address, deviceParams.refreshRate);
}
