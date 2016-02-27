import '../mamac_device.dart';
import '../devices.dart';
import '../node_parser.dart';

class MT150 extends MamacDevice {
  static const String type = 'mt150';
  static const String xmlFile = 'mt150ext.xml';

  String get deviceType => type;
  String get fileName => xmlFile;

  MT150(String address, int refreshRate) : super(address, refreshRate);

  Map<String, dynamic> definition(String nodeName, value) =>
      NodeParser.parseNode(nodeName, value);

  Map<String, dynamic> setValue(DeviceValue node, value) =>
      NodeParser.buildSetCommand(node, value);
}
