library dslink.mamac.nodes.device;

import 'package:dslink/dslink.dart';

class MamacDeviceNode extends SimpleNode {
  static const String isType = 'mamacDeviceNode';
  static Map<String, dynamic> definition() => {
    r'$is' : isType,
  };

  MamacDeviceNode(String path) : super(path);

}