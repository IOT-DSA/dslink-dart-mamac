library dslink.mamac.nodes.devices.cf201;

import '../mamac_device.dart';
import '../devices.dart';

class CF201 extends MamacDevice {
  static const String type = 'cf201';
  static const String xmlFile = 'cf201xml.txt';
  static const String _idPrefix = 'MAV_';

  String get deviceType => type;
  String get fileName => xmlFile;

  CF201(String address, int refreshRate) : super(address, refreshRate);

  Map<String, dynamic> definition(String nodeName, value) {
    var ret = DeviceValue.definition(value);

    if (nodeName.startsWith('FreezerCompressor')) {
      switch (nodeName) {
        case 'FreezerCompressorValue':
          ret['@cmdid'] = '${_idPrefix}03_00';
          ret[r'$type'] = 'number';
          ret[r'?value'] = num.parse(value);
          break;
        case 'FreezerCompressorRunTime':
          ret['@cmdid'] = '${_idPrefix}03_30';
          ret[r'$type'] = 'number';
          ret[r'?value'] = num.parse(value);
          break;
        // Undocumented
//        case 'FreezerCompressorAlert':
//          ret['@cmdid'] = '${_idPrefix}03_20';
//          ret[r'$type'] = 'number';
//          ret[r'?value'] = num.parse(value);
//          break;
        default:
          ret[r'$writable'] = 'never';
          break;
      }
    } else if (nodeName.startsWith('FreezerDefrost')) {
      switch (nodeName) {
        case 'FreezerDefrostValue':
          ret['@cmdid'] = '${_idPrefix}09_00';
          ret[r'$type'] = 'number';
          ret[r'?value'] = num.parse(value);
          break;
        // Undocumented
//        case 'FreezerDefrostCycleDaily':
//          ret['@cmdid'] = '${_idPrefix}09_31';
//          break;
        // Undocumented
//        case 'FreezerDefrostAlert':
//          ret['@cmdid'] = '${_idPrefix}09_20';
//          break;
        default:
          ret[r'$writable'] = 'never';
          break;
      }
    } else if (nodeName.startsWith('FreezerDoor')) {
      switch (nodeName) {
        case 'FreezerDoorValue':
          ret[r'$type'] = 'number';
          ret[r'?value'] = num.parse(value);
          break;
        // Undocumented
//        case 'FreezerDoorCycleDaily':
//          break;
//        case 'FreezerDoorOpenTimeDaily':
//          break;
//        case 'FreezerDoorAlert':
//          break;
//        case 'FreezerDoorOpenAlert':
//          break;
        default:
          ret[r'$writable'] = 'never';
          break;
      }
    } else if (nodeName.startsWith('Freezer')) {
      switch (nodeName) {
        case 'FreezerValue':
          ret['@cmdid'] = '${_idPrefix}01_00';
          ret[r'$type'] = 'number';
          ret[r'?value'] = num.parse(value);
          break;
        case 'FreezerUnits':
          ret['@cmdid'] = '${_idPrefix}01_05';
          ret[r'$type'] = 'enum[F,C]';
          break;
        // Undocumented
//        case 'FreezerAlert':
//          break;
        default:
          ret[r'$writable'] = 'never';
          break;
      }
    } else if (nodeName.startsWith('CoolerCompressor')) {
      switch (nodeName) {
        case 'CoolerCompressorValue':
          ret['@cmdid'] = '${_idPrefix}05_00';
          ret[r'$type'] = 'number';
          ret[r'?value'] = num.parse(value);
          break;
        // Undocumented
//        case 'CoolerCompressorRunTime':
//          break;
      // Undocumented
//        case 'CoolerCompressorAlert':
//          break;
        default:
          ret[r'$writable'] = 'never';
          break;
      }
      // Undocumented
//    } else if (nodeName.startsWith('CoolerDoor')) {
//      switch (nodeName) {
//        case 'CoolerDoorValue':
//          break;
//        case 'CoolerDoorCycleDaily':
//          break;
//        case 'CoolerDoorOpenTimeDaily':
//          break;
//        case 'CoolerDoorAlert':
//          break;
//        case 'CoolerDoorOpenAlert':
//          break;
//        default:
//          ret[r'$writable'] = 'never';
//          break;
//      }
    }

    switch (nodeName) {
      case 'NodeID':
        ret['@cmdid'] = '${_idPrefix}00_00';
        break;
      case 'CurrentTime':
        ret['@cmdid'] = '${_idPrefix}00_YY';
        break;
      case 'CurrentDate':
        ret['@cmdid'] = '${_idPrefix}00_YY';
        ret[r'$editor'] = 'daterange';
        break;
      default:
        ret[r'$writable'] = 'never';
        break;
    }

    return ret;
  }

  Map<String, dynamic> setValue(DeviceValue node, value) {
    var ret = {'cmd': null, 'value': null};
    String cmd = node.getAttribute('@cmdid');
    if (cmd == null) return null;
    var nodeName = node.name;



    print(cmd);
    return ret;
  }
}
