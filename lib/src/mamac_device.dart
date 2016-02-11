library dslink.mamac.nodes.device;

import 'package:dslink/dslink.dart';

import 'devices/devices.dart';

class MamacDeviceNode extends SimpleNode {
  static const String isType = 'mamacDeviceNode';
  static Map<String, dynamic> definition(Map params) => {
    r'$is' : isType,
    r'$$mm_ref' : params['refreshRate'],
    r'$$mm_url' : params['address'],
    r'$$mm_type': params['type']
  };

  MamacDevice _device;

  MamacDeviceNode(String path) : super(path);

  @override
  void onCreated() {
    var devType = getConfig(r'$$mm_type');
    var addr = getConfig(r'$mm_url');
    var refresh = getConfig(r'$$mm_ref');

    switch (devType) {
      case MT201.type:
        _device = new MT201(addr, refresh);
        break;
    }
  }

}