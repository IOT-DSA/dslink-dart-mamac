import 'dart:async';

import 'package:dslink/dslink.dart';

import 'devices.dart';
import 'mamac_device_commands.dart';

export 'mamac_device_commands.dart';

class MamacDeviceNode extends SimpleNode {
  static const String isType = 'mamacDeviceNode';
  static Map<String, dynamic> definition(Map params) => {
        r'$is': isType,
        wrap(ParamConstants.refreshRate): params[ParamConstants.refreshRate],
        wrap(ParamConstants.address): params[ParamConstants.address],
        wrap(ParamConstants.type): params[ParamConstants.type],
        wrap(ParamConstants.username): params[ParamConstants.username],
        wrap(ParamConstants.password): params[ParamConstants.password],
        RemoveDevice.pathName: RemoveDevice.definition()
      };

  static String wrap(String paramName) => ParamConstants.wrapParam(paramName);
  MamacDevice device;
  StreamSubscription _sub;

  MamacDeviceNode(String path) : super(path);

  @override
  void onCreated() {
    var devType = getConfig(wrap(ParamConstants.type));
    var address = getConfig(wrap(ParamConstants.address));
    var refresh = getConfig(wrap(ParamConstants.refreshRate));
    var username = getConfig(wrap(ParamConstants.username));
    var password = getConfig(wrap(ParamConstants.password));

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
    configs[wrap(ParamConstants.refreshRate)] =
        params[ParamConstants.refreshRate];
    configs[wrap(ParamConstants.address)] = params[ParamConstants.address];
    configs[wrap(ParamConstants.username)] = params[ParamConstants.username];
    configs[wrap(ParamConstants.password)] = params[ParamConstants.password];

    var currentType = getConfig(wrap(ParamConstants.type));
    var newParams = new DeviceParams()
      ..address = params[ParamConstants.address]
      ..refreshRate = params[ParamConstants.refreshRate]
      ..type = params[ParamConstants.type]
      ..username = params[ParamConstants.username]
      ..password = params[ParamConstants.password];

    bool hasTypeChanged() => currentType != params[ParamConstants.type];

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
