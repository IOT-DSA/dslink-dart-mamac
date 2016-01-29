library dslink.mamac.run;

import 'dart:async';

import 'package:dslink/dslink.dart';

import 'package:dslink_mamac/mamac_nodes.dart';

Future main(List<String> args) async {
  LinkProvider link;

  link = new LinkProvider(args, 'Mamac-', command: 'run', profiles: {
    AddDevice.isType : (String path) => new AddDevice(path)
  }, autoInitialize: false);

  link.init();
  link.addNode('/${AddDevice.pathName}', AddDevice.definition());
  await link.connect();
}