import 'dart:async';
import 'dart:io';

import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;

import 'node_parser.dart';
import 'mamac_device.dart';
import 'uri_parser.dart';

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

export 'devices/mt201.dart';
export 'devices/mt101.dart';
export 'devices/cl101.dart';
export 'devices/fz101.dart';
export 'devices/lt201.dart';
export 'devices/mt150.dart';
export 'devices/mt205.dart';
export 'devices/pc10144.dart';
export 'devices/pc10180.dart';
export 'devices/sm101.dart';

List<String> deviceTypes = [
  MT101.type,
  CF201.type,
  CL101.type,
  FZ101.type,
  LT201.type,
  MT150.type,
  MT201.type,
  MT205.type,
  PC10144.type,
  PC10180.type,
  SM101.type
];

abstract class MamacDevice {
  final DeviceParams deviceParams;

  String get deviceType;
  String get fileName;
  Stream<Map<String, dynamic>> get onUpdate => _controller.stream;
  List<LogEntry> logPaths = [];

  Uri rootUri;
  bool pendingUpdate = false;

  StreamController<Map<String, dynamic>> _controller;
  http.Client _client;

  xml.XmlDocument xmlDoc;

  MamacDevice(this.deviceParams) {
    var innerClient = new HttpClient()..maxConnectionsPerHost = 3;
    innerClient.authenticate = (Uri uri, String scheme, String realm) {
      innerClient.addCredentials(
          uri,
          realm,
          new HttpClientBasicCredentials(
              deviceParams.username, deviceParams.password));
      return true;
    };

    _client = new http.IOClient(innerClient);
    rootUri = parseAddress(deviceParams.address);
    _controller = new StreamController<Map<String, dynamic>>();
    new Timer.periodic(new Duration(seconds: deviceParams.refreshRate), update);
    update(null);
  }

  factory MamacDevice.fromParams(DeviceParams deviceParams) {
    switch (deviceParams.type) {
      case MT201.type:
        return new MT201(deviceParams);
      case MT101.type:
        return new MT101(deviceParams);
      case CF201.type:
        return new CF201(deviceParams);
      case CL101.type:
        return new CL101(deviceParams);
      case MT205.type:
        return new MT205(deviceParams);
      case FZ101.type:
        return new FZ101(deviceParams);
      case LT201.type:
        return new LT201(deviceParams);
      case MT150.type:
        return new MT150(deviceParams);
      case SM101.type:
        return new SM101(deviceParams);
      case PC10144.type:
        return new PC10144(deviceParams);
      case PC10180.type:
        return new PC10180(deviceParams);
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

  Map<String, dynamic> definition(String nodeName, value) =>
      NodeParser.parseNode(nodeName, value);

  Map<String, dynamic> setValue(DeviceValue node, value) =>
      NodeParser.buildSetCommand(node, value);
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

class LogEntry {
  final String csvPath;
  final String displayName;

  const LogEntry(this.displayName, this.csvPath);
}
