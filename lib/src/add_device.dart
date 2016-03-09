import 'package:quiver/strings.dart';

import 'package:dslink/dslink.dart';
import 'package:dslink/nodes.dart';

import 'mamac_device.dart';
import 'devices.dart';

class AddDevice extends SimpleNode {
  static const String isType = 'addDeviceNode';
  static const String pathName = 'Add_Device';
  static Map<String, dynamic> definition() => {
        r'$is': isType,
        r'$name': 'Add Device',
        r'$invokable': 'write',
        r'$params': [
          {
            'name': ParamConstants.name,
            'type': 'string',
            'placeholder': 'Device Name'
          },
          {
            'name': ParamConstants.address,
            'type': 'string',
            'placeholder': 'http://device.address.com'
          },
          {
            'name': ParamConstants.refreshRate,
            'type': 'number',
            'default': 30,
          },
          {
            'name': ParamConstants.username,
            'type': 'string',
            'placeholder': 'Username'
          },
          {'name': ParamConstants.password, 'type': 'password'},
        ],
        r'$columns': [
          {'name': 'success', 'type': 'bool', 'default': false},
          {'name': 'message', 'type': 'string', 'default': ''}
        ]
      };

  final LinkProvider _link;

  AddDevice(String path, this._link) : super(path);

  @override
  Map<String, dynamic> onInvoke(Map<String, dynamic> params) {
    var ret = {'success': false, 'message': ''};
    if (isEmpty(params['name'])) {
      ret['message'] = 'Device name is required';
      return ret;
    }

    if (isEmpty(params['address'])) {
      ret['message'] = 'Device address is required';
      return ret;
    }

    var name = NodeNamer.createName(params['name']);

    try {
      var definition = MamacDeviceNode.definition(params);

      provider.addNode('/$name', definition);

      _link.save();

      ret['success'] = true;
      ret['message'] = 'Success';
    } on FormatException catch(e) {
      ret['success'] = false;
      ret['message'] = e.message;
    }

    return ret;
  }
}
