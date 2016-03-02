import 'dart:async';
import 'dart:io';

import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;

import 'mamac_device.dart';

import 'devices/mt201.dart';
import 'devices/mt101.dart';
import 'devices/cf201.dart';
import 'devices/cl101.dart';
import 'devices/mt205.dart';
import 'devices/fz101.dart';
import 'devices/lt201.dart';
import 'devices/mt150.dart';
import 'devices/sm101.dart';
import 'devices/pc10144.dart';
import 'devices/pc10180.dart';

abstract class MamacDevice {
  final String address;
  final int refreshRate;

  String get deviceType;
  String get fileName;
  Stream<Map<String, dynamic>> get onUpdate => _controller.stream;

  Uri rootUri;
  bool pendingUpdate = false;

  StreamController<Map<String, dynamic>> _controller;
  http.Client _client;

  xml.XmlDocument xmlDoc;

  MamacDevice(this.address, this.refreshRate) {
    var innerClient = new HttpClient()..maxConnectionsPerHost = 3;
    innerClient.authenticate = (Uri uri, String scheme, String realm) {
      innerClient.addCredentials(
          uri, realm, new HttpClientBasicCredentials('username', 'password'));
      return true;
    };

    _client = new http.IOClient(innerClient);
    rootUri = Uri.parse(address);
    _controller = new StreamController<Map<String, dynamic>>();
    new Timer.periodic(new Duration(seconds: refreshRate), update);
    update(null);
  }

  factory MamacDevice.fromParams(DeviceParams deviceParams) {
    switch (deviceParams.type) {
      case MT201.type:
        return new MT201.fromParams(deviceParams);
      case MT101.type:
        return new MT101.fromParams(deviceParams);
      case CF201.type:
        return new CF201.fromParams(deviceParams);
      case CL101.type:
        return new CL101.fromParams(deviceParams);
      case MT205.type:
        return new MT205.fromParams(deviceParams);
      case FZ101.type:
        return new FZ101.fromParams(deviceParams);
      case LT201.type:
        return new LT201.fromParams(deviceParams);
      case MT150.type:
        return new MT150.fromParams(deviceParams);
      case SM101.type:
        return new SM101.fromParams(deviceParams);
      case PC10144.type:
        return new PC10144.fromParams(deviceParams);
      case PC10180.type:
        return new PC10180.fromParams(deviceParams);
    }
  }

  Future update(Timer t) async {
    if (pendingUpdate) return;
    pendingUpdate = true;
    var uri = rootUri.replace(path: fileName);

    var response = await _client.get(uri);

    xmlDoc = xml.parse(response.body);
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
        for (xml.XmlAttribute attr in el.attributes) {
          var attName = attr.name.local;
          var attVal = attr.value;
          ret[name]['@$attName'] = attVal;
        }
      }

      var iter = el.children.where((nd) => nd is xml.XmlElement);
      if (iter.length > 0) {
        ret[name] ??= new Map();
        for (var sub in iter) {
          ret[name].addAll(getData(sub));
        }
      } else {
        ret[name] = el.children.isNotEmpty ? el.firstChild.text : '';
      }
      return ret;
    }

    Map<String, dynamic> ret = {};

    var root = xmlDoc.findElements('Maverick');
    if (root.isEmpty) {
      root = xmlDoc.findElements('MaverickStat');
    }

    var doc = root.first;
    for (var node in doc.children) {
      if (node is! xml.XmlElement) continue;
      ret.addAll(getData(node));
    }

    return ret;
  }

  bool onSetValue(DeviceValue node, value) {
    var sendMap = setValue(node, value);
    if (sendMap == null || sendMap['cmd'] == null) return true;

    Uri uri;
    if (sendMap['cmd'] is Iterable) {
      for (var i = 0; i < sendMap['cmd'].length; i++) {
        var key = sendMap['cmd'][i];
        var val = sendMap['value'][i];
        uri = rootUri.replace(path: '/', queryParameters: {key: val});
        _client.post(uri);
      }
    } else {
      uri = rootUri.replace(
          path: '/', queryParameters: {sendMap['cmd']: sendMap['value']});
      _client.post(uri);
    }

    return false;
  }

  Map<String, dynamic> definition(String nodeName, value);
  Map<String, dynamic> setValue(node, value);
}

abstract class EnumHelper {
  static const List<String> scheduleDays = const [
    '',
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Occupied',
    'Unoccupied'
  ];
  static const List<String> HeatCoolAuto = const ['', 'Heat', 'Cool', 'Auto'];
  static String get enumHeatCoolAuto =>
      'enum[${HeatCoolAuto.where((el) => el.isNotEmpty).join(',')}]';
  static const List<String> AutoOn = const ['Auto', 'On'];
  static String get enumAutoOn => 'enum[${AutoOn.join(',')}]';
  static const List<String> OffOn = const ['Off', 'On'];
  static String get enumOffOn => 'enum[${OffOn.join(',')}]';
  static const List<String> AutoManual = const ['Auto', 'Manual'];
  static String get enumAutoManual => 'enum[${AutoManual.join(',')}]';
  static const List<String> DisabledEnabled = const ['Disabled', 'Enabled'];
  static String get enumDisabledEnabled => 'enum[${DisabledEnabled.join(',')}]';
  static const List<String> UnoccupiedOccupied = const [
    'Unoccupied',
    'Occupied'
  ];
  static String get enumUnoccupiedOccupied =>
      'enum[${UnoccupiedOccupied.join(',')}]';
  static const List<String> LogicOrAnd = const ['', 'OR', 'AND'];
  static String get enumLogicOrAnd =>
      'enum[${LogicOrAnd.where((el) => el.isNotEmpty).join(',')}]';
}

class ParamConstants {
  static const String type = 'type';
  static const String address = 'address';
  static const String refreshRate = 'refreshRate';
  static const String username = 'username';
  static const String password = 'password';
  static const String name = 'name';

  static String wrapParam(String param) => r'$$mm_' + param;
}

class DeviceParams {
  String type;
  String address;
  int refreshRate;
  String username;
  String password;
  String name;
}
