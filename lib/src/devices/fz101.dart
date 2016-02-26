import '../mamac_device.dart';
import '../devices.dart';
import '../node_parser.dart';

class FZ101 extends MamacDevice {
  static const String type = 'fz101';
  static const String xmlFile = 'fz101.xml';

  String get deviceType => type;
  String get fileName => xmlFile;

  FZ101(String address, int refreshRate) : super(address, refreshRate);

  Map<String, dynamic> definition(String nodeName, value) =>
      NodeParser.parseNode(nodeName, value);

  Map<String, dynamic> setValue(DeviceValue node, value) =>
      NodeParser.buildSetCommand(node, value);
}
