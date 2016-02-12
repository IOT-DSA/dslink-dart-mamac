library dslink.mamac.nodes.add_device;

import 'package:dslink/dslink.dart';
import 'package:dslink/nodes.dart';

import 'mamac_device.dart';

class AddDevice extends SimpleNode {
  static const String isType = 'addDeviceNode';
  static const String pathName = 'Add_Device';
  static Map<String, dynamic> definition() => {
    r'$is' : isType,
    r'$name' : 'Add Device',
    r'$invokable' : 'write',
    r'$params' : [
      {
        'name' : 'name',
        'type' : 'string',
        'placeholder' : 'Device Name'
      },
      {
        'name' : 'address',
        'type' : 'string',
        'placeholder' : 'http://device.address.com'
      },
      {
      'name' : 'type',
      'type' : 'enum[cf101,cf201,fz101,lt201,mt101,mt150,mt201,mt205,pc10144,pc10180,sm101]'
      },
      {
        'name' : 'refreshRate',
        'type' : 'number',
        'default' : 30
      }
    ],
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

  AddDevice(String path, this._link) : super(path);

  @override
  Map<String, dynamic> onInvoke(Map<String, dynamic> params) {
    var ret = { 'success' : false, 'message' : '' };
    if (params['name'] == null || params['name'].trim().isEmpty) {
      ret['message'] = 'Device name is required';
      return ret;
    }
    if (params['address'] == null || params['address'].trim().isEmpty) {
      ret['message'] = 'Device address is required';
      return ret;
    }

    var name = NodeNamer.createName(params['name']);

    provider.addNode('/$name', MamacDeviceNode.definition(params));
    _link.save();

    ret['success'] = true;
    ret['message'] = 'Success';
    return ret;
  }
}