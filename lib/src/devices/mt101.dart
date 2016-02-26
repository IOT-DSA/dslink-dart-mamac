library dslink.mamac.nodes.devices.mt101;

import '../mamac_device.dart';
import '../devices.dart';
import '../node_parser.dart';

class MT101 extends MamacDevice {
  static const String type = 'mt101';
  static const String xmlFile = 'mt101ext.xml';

  String get deviceType => type;
  String get fileName => xmlFile;

  MT101(String address, int refreshRate) : super(address, refreshRate);

  Map<String, dynamic> definition(String nodeName, value) {
    return NodeParser.parseNode(nodeName, value);
  }

  Map<String, dynamic> setValue(DeviceValue node, value) {
    return NodeParser.buildSetCommand(node, value);
  }
}
