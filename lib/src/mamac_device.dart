import 'dart:async';

import 'package:dslink/dslink.dart';

import 'devices.dart';
import 'mamac_device_commands.dart';

export 'mamac_device_commands.dart';

class MamacDeviceNode extends SimpleNode {
  static const String isType = 'mamacDeviceNode';
  static Map<String, dynamic> definition(Map params) => {
        r'$is': isType,
        r'$$mm_ref': params['refreshRate'],
        r'$$mm_url': params['address'],
        r'$$mm_type': params['type'],
        r'$$mm_username': params['username'],
        r'$$mm_password': params['password'],
        RemoveDevice.pathName: RemoveDevice.definition()
      };

  MamacDevice device;
  StreamSubscription _sub;

  MamacDeviceNode(String path) : super(path);

  @override
  void onCreated() {
    var devType = getConfig(r'$$mm_type');
    var address = getConfig(r'$$mm_url');
    var refresh = getConfig(r'$$mm_ref');
    var username = getConfig(r'$$mm_username');
    var password = getConfig(r'$$mm_password');

    var deviceParams = new DeviceParams()
      ..address = address
      ..type = devType
      ..refreshRate = refresh
      ..username = username
      ..password = password;

    print('Type: $devType, Address: $address, Refresh: $refresh');

    device = new MamacDevice.fromParams(deviceParams);
    _sub = device.onUpdate.listen(updateDevice);
  }

  void update(Map params) {
    configs[r'$$mm_ref'] = params['refreshRate'];
    configs[r'$$mm_url'] = params['address'];
    configs[r'$$mm_username'] = params['username'];
    configs[r'$$mm_password'] = params['password'];

    var currentType = getConfig(r'$$mm_type');
    var newParams = new DeviceParams()
      ..address = params['address']
      ..refreshRate = params['refreshRate']
      ..type = params['type']
      ..username = params['username']
      ..password = params['password'];

    bool hasTypeChanged() => currentType != params['type'];

    if (hasTypeChanged()) {
      device = new MamacDevice.fromParams(newParams);
      // TODO: Need to remove subnodes because they may not match the new type.
    }
  }

  void updateDevice(Map<String, dynamic> data) {
    void valueUpdate(Map<String, dynamic> map, String pth) {
      for (String key in map.keys) {
        var nd = provider.getNode('$pth/$key');
        if (map[key] is String) {
          if (nd == null) {
            provider.addNode('$pth/$key', device.definition(key, map[key]));
          } else {
            var def = device.definition(key, map[key]);
            nd.updateValue(def['?value']);
          }
        } else if (map[key] is Map) {
          if (nd == null) {
            var newNd = provider.getOrCreateNode('$pth/$key');
            valueUpdate(map[key], newNd.path);
          } else {
            valueUpdate(map[key], nd.path);
          }
        }
      }
    }

    valueUpdate(data, path);
  }
}

class DeviceValue extends SimpleNode {
  static const String isType = 'deviceValue';
  static Map<String, dynamic> definition(value) => {
        r'$is': isType,
        r'$type': 'string',
        r'$writable': 'write',
        r'?value': value
      };

  MamacDevice _device;

  DeviceValue(String path) : super(path);

  @override
  void onCreated() {
    var p = parent;
    while (p is! MamacDeviceNode) {
      p = p.parent;
      if (p == null) break;
    }

    if (p != null) {
      _device = (p as MamacDeviceNode).device;
    }
  }

  @override
  bool onSetValue(dynamic newValue) => _device?.onSetValue(this, newValue);
}
