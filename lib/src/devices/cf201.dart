library dslink.mamac.nodes.devices.cf201;

import '../mamac_device.dart';
import '../devices.dart';

class CF201 extends MamacDevice {
  static const String type = 'cf201';
  static const String xmlFile = 'cf201.xml';
  static const String _idPrefix = 'MAV_';

  String get deviceType => type;
  String get fileName => xmlFile;

  CF201(String address, int refreshRate) : super(address, refreshRate);

  Map<String, dynamic> definition(String nodeName, value) {
    var ret = DeviceValue.definition(value);

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
      case 'FreezerUnits':
        ret['@cmdid'] = '${_idPrefix}01_05';
        ret[r'$type'] = 'enum[F,C]';
        break;
      case 'CoolerUnits':
        ret['@cmdid'] = '${_idPrefix}01_05';
        ret[r'$type'] = 'enum[F,C]';
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

    switch (nodeName) {
      case 'CurrentTime':
        ret['cmd'] = [
          cmd.replaceFirst('YY', '22'),
          cmd.replaceFirst('YY', '23'),
          cmd.replaceFirst('YY', '24')
        ];
        ret['values'] = (value as String).split(':').toList();
        break;
      case 'CurrentDate':
        var dates =
            (value as String).split('/').map((el) => DateTime.parse(el));
        ret['cmd'] = [
          cmd.replaceFirst('YY', '25'),
          cmd.replaceFirst('YY', '26'),
          cmd.replaceFirst('YY', '27')
        ];
        ret['value'] = [dates[0].month, dates[0].day, (dates[0].year % 100)];
        break;
      case 'CoolerUnits':
        ret['cmd'] = cmd;
        ret['value'] = value == 'F' ? '1' : '2';
        break;
      case 'FreezerUnits':
        ret['cmd'] = cmd;
        ret['value'] = value == 'F' ? '1' : '2';
        break;
      default:
        ret['cmd'] = cmd;
        ret['value'] = value;
        break;
    }

    print(cmd);
    return ret;
  }
}
