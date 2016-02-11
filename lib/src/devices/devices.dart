library dslink.mamac.devices;

import 'dart:async';

import '../mamac_client.dart';

export 'mt201.dart';

abstract class MamacDevice {
  final String address;
  final int refreshRate;

  String get deviceType;
  String get fileName;

  final MamacClient client;
  Uri rootUri;

  // TODO: Use stream controller to push updates to 'node'.

  MamacDevice(this.address, this.refreshRate) : client = new MamacClient() {
    rootUri = Uri.parse(address);
  }

  Future update() async {
    var uri = rootUri.replace(path: fileName);

    var res = await client.get(uri);
  }

}