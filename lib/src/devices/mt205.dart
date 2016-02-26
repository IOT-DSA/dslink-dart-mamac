import '../mamac_device.dart';
import '../devices.dart';
import '../node_parser.dart';

class MT205 extends MamacDevice {
  static const String type = 'mt205';
  static const String xmlFile = 'mt205ext.xml';
  String get deviceType => type;
  String get fileName => xmlFile;

  MT205(String address, int refreshRate) : super(address, refreshRate);

  Map<String, dynamic> definition(String nodeName, value) =>
      NodeParser.parseNode(nodeName, value);

  Map<String, dynamic> setValue(DeviceValue node, value) =>
      NodeParser.buildSetCommand(node, value);
}
