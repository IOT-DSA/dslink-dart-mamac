import '../mamac_device.dart';
import '../devices.dart';
import '../node_parser.dart';

class PC10144 extends MamacDevice {
  static const String type = 'pc10144';
  static const String xmlFile = 'pc10144.xml';

  String get deviceType => type;
  String get fileName => xmlFile;

  // TODO: Check for this device
  // The POST document doesn't fit with the xml file.
  PC10144(String address, int refreshRate) : super(address, refreshRate);

  Map<String, dynamic> definition(String nodeName, value) =>
      NodeParser.parseNode(nodeName, value);

  Map<String, dynamic> setValue(DeviceValue node, value) =>
      NodeParser.buildSetCommand(node, value);
}
