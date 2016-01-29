library dslink.mamac.nodes.add_device;

import 'dart:async';

import 'package:dslink/dslink.dart';

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
        'name' : 'refreshInterval',
        'type' : 'number',
        'default' : 30
      },
      {
        'name' : 'type',
        'type' : 'enum[cf101,cf201,fz101,lt201,mt101,mt150,mt201,mt205,pc10144,pc10180,sm101]'
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

  AddDevice(String path) : super(path);

  @override
  Map<String, dynamic> onInvoke(Map<String, dynamic> params) {
    var ret = { 'success' : false, 'message' : '' };
  }
}