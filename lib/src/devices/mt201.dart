import '../mamac_device.dart';
import '../devices.dart';
import '../node_parser.dart';

class MT201 extends MamacDevice {
  static const String type = 'mt201';
  static const String xmlFile = 'mt201ext.xml';

  String get deviceType => type;
  String get fileName => xmlFile;

  MT201(String address, int refreshRate) : super(address, refreshRate);

  MT201.fromParams(DeviceParams deviceParams)
      : super(deviceParams.address, deviceParams.refreshRate);

  Map<String, dynamic> definition(String nodeName, value) =>
      NodeParser.parseNode(nodeName, value);

  Map<String, dynamic> setValue(DeviceValue node, value) =>
      NodeParser.buildSetCommand(node, value);
}
