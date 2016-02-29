import '../mamac_device.dart';
import '../devices.dart';
import '../node_parser.dart';

class SM101 extends MamacDevice {
  static const String type = 'sm101';
  static const String xmlFile = 'sm101.xml';

  String get deviceType => type;
  String get fileName => xmlFile;

  // TODO: Verify for this device -- the xml and post document don't make sense
  SM101(String address, int refreshRate) : super(address, refreshRate);

  SM101.fromParams(DeviceParams deviceParams)
      : super(deviceParams.address, deviceParams.refreshRate);

  Map<String, dynamic> definition(String nodeName, value) =>
      NodeParser.parseNode(nodeName, value);

  Map<String, dynamic> setValue(DeviceValue node, value) =>
      NodeParser.buildSetCommand(node, value);
}
