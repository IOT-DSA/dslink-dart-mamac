library dslink.mamac.nodes.device.commands;

import 'package:dslink/dslink.dart';

import 'mamac_device.dart';

class RemoveDevice extends SimpleNode {
  static const String isType = 'removeDeviceNode';
  static const String pathName = 'Remove_Device';
  static Map<String, dynamic> definition() => {
        r'$is': isType,
        r'$name': 'Remove Device',
        r'$invokable': 'write',
        r'$params': [],
        r'$columns': [
          {'name': 'success', 'type': 'bool', 'default': false},
          {'name': 'message', 'type': 'string', 'default': ''}
        ]
      };

  final LinkProvider _link;

  RemoveDevice(String path, this._link) : super(path);

  @override
  Map<String, dynamic> onInvoke(Map<String, dynamic> params) {
    var ret = {'success': true, 'message': 'Success!'};

    provider.removeNode('${parent.path}');
    _link.save();

    return ret;
  }
}

class EditDevice extends SimpleNode {
  static const String isType = 'editDeviceNode';
  static const String pathName = 'Edit_Device';
  static Map<String, dynamic> definition(Map params) => {
        r'$is': isType,
        r'$name': 'Edit Device',
        r'$invokable': 'write',
        r'$params': [
          {'name': 'address', 'type': 'string', 'default': params['address']},
          {
            'name': 'type',
            'type':
                'enum[cf101,cf201,fz101,lt201,mt101,mt150,mt201,mt205,pc10144,pc10180,sm101]',
            'default': params['type']
          },
          {
            'name': 'refreshRate',
            'type': 'number',
            'default': params['refreshRate']
          },
        ],
        r'$columns': [
          {'name': 'success', 'type': 'bool', 'default': false},
          {'name': 'message', 'type': 'string', 'default': ''}
        ]
      };

  EditDevice(String path) : super(path);

  @override
  Map<String, dynamic> onInvoke(Map<String, dynamic> params) {
    var ret = {'success': false, 'message': ''};

    if (params['address'] == null || params['address'].trim().isEmpty) {
      ret['message'] = 'Device address is required';
      return ret;
    }

    (parent as MamacDeviceNode).update(params);
  }
}
