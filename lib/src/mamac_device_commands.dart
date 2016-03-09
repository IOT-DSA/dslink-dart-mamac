import 'package:dslink/dslink.dart';
import 'package:quiver/strings.dart';

import '../services.dart';

import 'mamac_device.dart';
import 'devices.dart';
import 'dart:async';

class RemoveDeviceNode extends SimpleNode {
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

  RemoveDeviceNode(String path, this._link) : super(path);

  @override
  Map<String, dynamic> onInvoke(Map<String, dynamic> params) {
    var ret = {'success': true, 'message': 'Success!'};

    provider.removeNode('${parent.path}');
    _link.save();

    return ret;
  }
}

class EditDeviceNode extends SimpleNode {
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

  EditDeviceNode(String path) : super(path);

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

class GetHistoryNode extends SimpleNode {
  static const String isType = 'getHistoryNode';
  static const String pathName = 'Get_History';
  static const String childNodePrefix = 'History_';

  static Map<String, dynamic> definition() => {
        r'$is': isType,
        r'$name': 'Get History',
        r'$invokable': 'write',
        r'$params': [],
        r'$columns': [
          {'name': 'success', 'type': 'bool', 'default': false},
          {'name': 'message', 'type': 'string', 'default': ''}
        ]
      };

  MamacDevice _device;
  GetLogsService _getLogsService = new GetLogsService();
  LinkProvider _link;

  void set device(MamacDevice device) {
    _device = device;

    if (device.logPaths.isEmpty) {
      return;
    }

    var entries = device.logPaths.map((LogEntry e) => e.displayName).join(',');

    var paramsNode = [
      {'name': 'logEntry', 'type': 'enum[${entries}]'}
    ];

    configs[r'$params'] = paramsNode;
  }

  GetHistoryNode(String path, this._link) : super(path);

  @override
  Future<Map<String, dynamic>> onInvoke(Map<String, dynamic> params) async {
    var ret = {'success': false, 'message': ''};

    var logEntryDisplayName = (params['logEntry']) as String;

    if (isEmpty(logEntryDisplayName)) {
      ret['message'] = 'Invalid logEntry';
      return ret;
    }

    var logEntry = _device.logPaths
        .firstWhere((LogEntry e) => e.displayName == logEntryDisplayName);

    try {
      var logs = await _getLogsService.fetchCsvLogs(_device, logEntry);

      var definition = DeviceValue.definition(logs);
      definition[r'$writable'] = 'never';

      var displayNameToPath = logEntryDisplayName.replaceAll(' ', '_');
      _link.addNode(
          '${parent.path}/$childNodePrefix$displayNameToPath', definition);

      ret['success'] = true;
      return ret;
    } on Exception {
      ret['message'] = 'An error occurred when fetching the logs';
      return ret;
    }
  }
}
