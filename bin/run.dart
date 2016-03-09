import 'dart:async';

import 'package:dslink/dslink.dart';
import 'package:dslink_mamac/mamac_nodes.dart';

Future main(List<String> args) async {
  LinkProvider link;

  link = new LinkProvider(args, 'Mamac-',
      command: 'run',
      profiles: {
        AddDevice.isType: (String path) => new AddDevice(path, link),
        MamacDeviceNode.isType: (String path) => new MamacDeviceNode(path),
        RemoveDeviceNode.isType: (String path) => new RemoveDeviceNode(path, link),
        GetLogsNode.isType: (String path) => new GetLogsNode(path, link),
        DeviceValue.isType: (String path) => new DeviceValue(path),
      },
      autoInitialize: false);

  link.init();
  link.addNode('/${AddDevice.pathName}', AddDevice.definition());
  await link.connect();
}
