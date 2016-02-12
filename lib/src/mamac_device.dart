library dslink.mamac.nodes.device;

import 'dart:async';

import 'package:dslink/dslink.dart';

import 'devices.dart';
import 'mamac_device_commands.dart';

export 'mamac_device_commands.dart';

class MamacDeviceNode extends SimpleNode {
  static const String isType = 'mamacDeviceNode';
  static Map<String, dynamic> definition(Map params) => {
    r'$is' : isType,
    r'$$mm_ref' : params['refreshRate'],
    r'$$mm_url' : params['address'],
    r'$$mm_type': params['type'],
    RemoveDevice.pathName : RemoveDevice.definition()
  };

  MamacDevice _device;
  StreamSubscription _sub;


  MamacDeviceNode(String path) : super(path);

  @override
  void onCreated() {
    var devType = getConfig(r'$$mm_type');
    var addr = getConfig(r'$$mm_url');
    var refresh = getConfig(r'$$mm_ref');

    print('Type: $devType, Address: $addr, Refresh: $refresh');

    _device = new MamacDevice.fromType(devType, addr, refresh);
    _sub = _device.onUpdate.listen(updateDevice);

  }

  void update(Map params) {
    configs[r'$$mm_ref'] = params['refreshRate'];
    configs[r'$$mm_url'] = params['address'];

    var curType = getConfig(r'$$mm_type');
    if (curType != params['type']) {
      _device = new MamacDevice.fromType(params['type'], params['address'],
          params['refreshRate']);
      // TODO: Need to remove subnodes because they may not match the new type.
    }
  }

  void updateDevice(Map<String, dynamic> data) {
    // TODO: Update nodes

    var node = {};

    for (String key in data.keys) {
      print('Key: $key, Data: ${data[key]}');

      var nd = provider.getNode('$path/$key');
      if (data[key] is String) {
        if(nd == null) {
          provider.addNode('$path/$key', DeviceValue.definition(data[key]));
        } else {
          nd.updateValue(data[key]);
        }
      } else {
        continue;
      }

    }
  }
}

class DeviceValue extends SimpleNode {
  static const String isType = 'deviceValue';
  static Map<String, dynamic> definition(value) => {
    r'$is' : isType,
    r'$type': 'string',
    r'$writable' : 'write',
    r'?value': value
  };

  DeviceValue(String path) : super(path);
}