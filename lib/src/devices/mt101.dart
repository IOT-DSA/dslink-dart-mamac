library dslink.mamac.nodes.devices.mt101;

import '../mamac_device.dart';
import '../devices.dart';
import 'node_parser.dart';

class MT101 extends MamacDevice {
  static const String type = 'mt101';
  static const String xmlFile = 'mt101ext.xml';
  static const String _idPrefix = 'MAV_';

  String get deviceType => type;
  String get fileName => xmlFile;

  NodeParser _nodeParser;

  MT101(String address, int refreshRate) : super(address, refreshRate) {
    _nodeParser = new NodeParser(_idPrefix);
  }

  Map<String, dynamic> definition(String nodeName, value) {
    var ret = DeviceValue.definition(value);

    return _nodeParser.parseNode(nodeName, value, ret);
  }

  Map<String, dynamic> setValue(DeviceValue node, value) {
    return _nodeParser.buildSetCommand(node, value);
  }
}
