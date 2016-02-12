library dslink.mamac.devices;

import 'dart:async';

import 'package:xml/xml.dart' as xml;

import '../mamac_client.dart';

abstract class MamacDevice {
  final String address;
  final int refreshRate;

  String get deviceType;
  String get fileName;
  Stream<Map<String, dynamic>> get onUpdate => _controller.stream;

  final MamacClient client;
  Uri rootUri;
  bool pendingUpdate = false;

  StreamController<Map<String, dynamic>> _controller;
  Timer _refreshTimer;

  xml.XmlDocument xmlDoc;

  // TODO: Use stream controller to push updates to 'node'.

  MamacDevice(this.address, this.refreshRate) : client = new MamacClient() {
    rootUri = Uri.parse(address);
    _controller = new StreamController<Map<String, dynamic>>();
    _refreshTimer = new Timer.periodic(new Duration(seconds: refreshRate),
        update);
    update(null);
  }

  factory MamacDevice.fromType(String type, String address, int refreshRate) {
    switch (type) {
      case MT201.type:
        return new MT201(address, refreshRate);
    }
  }

  Future update(Timer t) async {
    if (pendingUpdate) return;
    pendingUpdate = true;
    var uri = rootUri.replace(path: fileName);

    var doc = await client.get(uri);
    if (doc == null) {
      return;
    }

    xmlDoc = xml.parse(doc);
    var dataMap = processData();
    _controller.add(dataMap);
    pendingUpdate = false;
  }


  Map<String, dynamic> processData() {
    Map<String, dynamic> getData(xml.XmlElement el) {
      var ret = new Map<String, dynamic>();
      var name = el.name.local;
      if (el.attributes.isNotEmpty) {
        name = '${name}_${el.attributes.map((attr) => attr.value).join('_')}';
        ret[name] = new Map();
        for(xml.XmlAttribute attr in el.attributes) {
          var attName = attr.name.local;
          var attVal = attr.value;
          ret[name]['_$attName'] = attVal;
        }
      }

      var iter = el.children.where((nd) => nd is xml.XmlElement);
      if (iter.length > 0) {
        ret[name] ??= new Map();
        for (var sub in iter) {
          ret[name].addAll(getData(sub));
        }
      } else {
        ret[name] = el.firstChild.text;
      }
      return ret;
    }

    Map<String, dynamic> ret = {};

    var doc = xmlDoc.findElements('MaverickStat').first;
    for (var node in doc.children) {
      if (node is! xml.XmlElement) continue;
      ret.addAll(getData(node));
    }

    return ret;
  }
}

class MT201 extends MamacDevice {
  static const String type = 'mt201';
  static const String xmlFile = 'mt201ext.xml';

  String get deviceType => type;
  String get fileName => xmlFile;

  MT201(String address, int refreshRate) : super(address, refreshRate);
}