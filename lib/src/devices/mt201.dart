library dslink.mamac.nodes.devices.mt201;

import '../mamac_device.dart';
import '../devices.dart';
import 'node_parser.dart';

class MT201 extends MamacDevice {
  static const String type = 'mt201';
  static const String xmlFile = 'mt201ext.xml';
  static const String _idPrefix = 'MAV_';

  String get deviceType => type;
  String get fileName => xmlFile;

  NodeParser _nodeParser;

  MT201(String address, int refreshRate) : super(address, refreshRate) {
    _nodeParser = new NodeParser(_idPrefix);
  }

  Map<String, dynamic> definition(String nodeName, value) {
    return _nodeParser.parseNode(nodeName, value);
  }

  Map<String, dynamic> setValue(DeviceValue node, value) {
    return _nodeParser.buildSetCommand(node, value);
  }
}
