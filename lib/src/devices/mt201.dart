library dslink.mamac.nodes.devices.mt201;

import '../mamac_device.dart';
import '../devices.dart';

class MT201 extends MamacDevice {
  static const String type = 'mt201';
  static const String xmlFile = 'mt201ext.xml';
  static const String _idPrefix = 'MAV_';

  String get deviceType => type;
  String get fileName => xmlFile;

  MT201(String address, int refreshRate) : super(address, refreshRate);

  Map<String, dynamic> definition(String nodeName, value) {
    var ret = DeviceValue.definition(value);
    var ind = -1;

    if (nodeName.startsWith('RoomTemp')) {
      ret[r'$writable'] = 'never';
      print(' ********** Hit: $nodeName');
    } else if ((ind = EnumHelper.scheduleHeatCool.indexOf(nodeName)) != -1) {
      ret['@cmdid'] = '${_idPrefix}4X_0$ind';
      ret[r'$type'] = 'number';
    } else if ((ind = EnumHelper.scheduleFan.indexOf(nodeName) != -1)) {
      ret['@cmdid'] = '${_idPrefix}3X_0$ind';
      ret[r'$type'] = EnumHelper.enumAutoOn;
      ret[r'?value'] = EnumHelper.AutoOn[int.parse(value)];
    } else {
      switch (nodeName) {
        case 'NodeID':
          ret['@cmdid'] = '${_idPrefix}00_00';
          break;
      // TODO: Date/Times
        case 'SystemMode':
          ret['@cmdid'] = '${_idPrefix}70_02';
          ret[r'$type'] = 'enum[Heat,Cool,Auto]';
          break;
        case 'TempUnits':
          ret['@cmdid'] = '${_idPrefix}70_01';
          ret[r'$type'] = 'enum[F,C]';
          break;
        case 'FanValue':
          ret['@cmdid'] = '${_idPrefix}05_00';
          ret[r'$type'] = EnumHelper.enumOffOn;
          break;
        case 'FanControl':
          ret['@cmdid'] = '${_idPrefix}05_16';
          ret[r'$type'] = EnumHelper.enumAutoManual;
          break;
        case 'HeatValue':
          ret['@cmdid'] = '${_idPrefix}06_00';
          ret[r'$type'] = EnumHelper.enumOffOn;
          break;
        case 'HeatControl':
          ret['@cmdid'] = '${_idPrefix}06_16';
          ret[r'$type'] = EnumHelper.enumAutoManual;
          break;
        case 'Heat2Value':
          ret['@cmdid'] = '${_idPrefix}08_00';
          ret[r'$type'] = EnumHelper.enumOffOn;
          break;
        case 'Heat2Control':
          ret['@cmdid'] = '${_idPrefix}08_16';
          ret[r'$type'] = EnumHelper.enumAutoManual;
          break;
        case 'CoolValue':
          ret['@cmdid'] = '${_idPrefix}07_00';
          ret[r'$type'] = EnumHelper.enumOffOn;
          break;
        case 'CoolControl':
          ret['@cmdid'] = '${_idPrefix}07_16';
          ret[r'$type'] = EnumHelper.enumAutoManual;
          break;
        case 'Cool2Value':
          ret['@cmdid'] = '${_idPrefix}09_00';
          ret[r'$type'] = EnumHelper.enumOffOn;
          break;
        case 'Cool2Control':
          ret['@cmdid'] = '${_idPrefix}09_16';
          ret[r'$type'] = EnumHelper.enumAutoManual;
          break;
        case 'StartDate':
        case 'EndDate':
          ret['@cmdid'] = '${_idPrefix}XX_YY';
          ret[r'$editor'] = 'date';
          break;
        case 'DateType':
          ret['@cmdid'] = '${_idPrefix}XX_03';
          ret[r'$type'] = EnumHelper.enumUnoccupiedOccupied;
          ret['?value'] = EnumHelper.UnoccupiedOccupied[int.parse(value)];
          break;
        // ALERTS
        case 'AlertEnabled':
          ret['@cmdid'] = '${_idPrefix}01_11';
          ret[r'$type'] = EnumHelper.enumDisabledEnabled;
          ret['?value'] = EnumHelper.DisabledEnabled[int.parse(value)];
          break;
        // LOGGING
        case 'LoggingEnabled':
          ret['@cmdid'] = '${_idPrefix}11_01';
          ret[r'$type'] = EnumHelper.enumDisabledEnabled;
          ret['?value'] = EnumHelper.DisabledEnabled[int.parse(value)];
          break;
        case 'MaxSamples':
          ret['@cmdid'] = '${_idPrefix}11_02';
          ret[r'$type'] = 'number';
          ret[r'$editor'] = 'int';
          ret[r'$max'] = 2048;
          ret[r'$min'] = 0;
          ret['?value'] = int.parse(value);
          break;
        case 'SampleRate':
          ret['@cmdid'] = '${_idPrefix}11_YY';
          break;
      }
    }

    return ret;
  }

  bool setValue(DeviceValue node, value) {

  }
}