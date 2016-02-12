library dslink.mamac.nodes.device.commands;

import 'package:dslink/dslink.dart';

class RemoveDevice extends SimpleNode {
  static const String isType = 'removeDeviceNode';
  static const String pathName = 'Remove_Device';
  static Map<String, dynamic> definition() => {
    r'$is' : isType,
    r'$name' : 'Remove Device',
    r'$invokable' : 'write',
    r'$params' : [],
    r'$columns' : [
      {
        'name' : 'success',
        'type' : 'bool',
        'default' : false
      },
      {
        'name' : 'message',
        'type' : 'string',
        'default': ''
      }
    ]
  };

  final LinkProvider _link;

  RemoveDevice(String path, this._link) : super(path);

  @override
  Map<String, dynamic> onInvoke(Map<String, dynamic> params) {
    var ret = { 'success' : true, 'message' : 'Success!' };

    provider.removeNode('${parent.path}');
    _link.save();

    return ret;
  }
}