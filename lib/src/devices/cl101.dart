import '../mamac_device.dart';
import '../devices.dart';
import '../node_parser.dart';

class CL101 extends MamacDevice {
  static const String type = 'cl101';
  static const String xmlFile = 'cl101.xml';

  String get deviceType => type;
  String get fileName => xmlFile;

  CL101(String address, int refreshRate) : super(address, refreshRate);

  Map<String, dynamic> definition(String nodeName, value) =>
      NodeParser.parseNode(nodeName, value);

  Map<String, dynamic> setValue(DeviceValue node, value) =>
      NodeParser.buildSetCommand(node, value);
}
