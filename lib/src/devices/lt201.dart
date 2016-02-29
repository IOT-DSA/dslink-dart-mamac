import '../mamac_device.dart';
import '../devices.dart';
import '../node_parser.dart';

class LT201 extends MamacDevice {
  static const String type = 'LT201';
  static const String xmlFile = 'lt201.xml';

  String get deviceType => type;
  String get fileName => xmlFile;

  LT201(String address, int refreshRate) : super(address, refreshRate);

  LT201.fromParams(DeviceParams deviceParams)
      : super(deviceParams.address, deviceParams.refreshRate);

  Map<String, dynamic> definition(String nodeName, value) =>
      NodeParser.parseNode(nodeName, value);

  Map<String, dynamic> setValue(DeviceValue node, value) =>
      NodeParser.buildSetCommand(node, value);
}
