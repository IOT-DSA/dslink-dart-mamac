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
    } else if ((ind = EnumHelper.scheduleHeatCool.indexOf(nodeName)) != -1) {
      ret['@cmdid'] = '${_idPrefix}4X_0$ind';
      ret[r'$type'] = 'number';
    } else if ((ind = EnumHelper.scheduleFan.indexOf(nodeName)) != -1) {
      ret['@cmdid'] = '${_idPrefix}3X_0$ind';
      ret[r'$type'] = EnumHelper.enumAutoOn;
      ret[r'?value'] = EnumHelper.AutoOn[int.parse(value)];
    } else if ((ind = EnumHelper.scheduleStartEnd.indexOf(nodeName)) != -1) {
      ret['@cmdid'] = '${_idPrefix}2X_YY';
    } else {
      switch (nodeName) {
        case 'NodeID':
          ret['@cmdid'] = '${_idPrefix}00_00';
          break;
        case 'CurrentTime':
          ret['@cmdid'] = '${_idPrefix}00_YY';
          break;
        case 'CurrentDate':
          ret['@cmdid'] = '${_idPrefix}00_YY';
          ret[r'$editor'] = 'date';
          break;
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

  Map<String, dynamic> setValue(DeviceValue node, value) {
    var ret = { 'cmd' : null, 'value' : null };
    String cmd = node.getAttribute('@cmdid');
    if (cmd == null) return null;
    var nodeName = node.name;

    if (EnumHelper.scheduleHeatCool.contains(nodeName)) {
      var parentNames = node.parent.name.split('_');
      if (parentNames.length > 1) {
        var dayInd = EnumHelper.scheduleDays.indexOf(parentNames[1]);
        ret['cmd'] = cmd.replaceFirst('X', '$dayInd');
        ret['value'] = value;
      }
    } else if (EnumHelper.scheduleFan.contains(nodeName)) {
      var parentNames = node.parent.name.split('_');
      if (parentNames.length > 1) {
        var dayInd = EnumHelper.scheduleDays.indexOf(parentNames[1]);
        ret['cmd'] = cmd.replaceFirst('X', '$dayInd');
        ret['value'] = EnumHelper.AutoOn.indexOf(value);
      }
    } else if (EnumHelper.scheduleStartEnd.contains(nodeName)) {
      var parentNames = node.parent.name.split('_');
      if (parentNames.length <= 1) return null;
      var dayInd = EnumHelper.scheduleDays.indexOf(parentNames[1]);
      var baseCmd = cmd.replaceFirst('X', '$dayInd');
      var hourMin = value.split(':');
      if (hourMin.length <= 1) return null;
      ret['cmd'] = [];
      ret['value'] = hourMin;
      switch (nodeName) {
        case 'MorningStart':
          ret['cmd'].add(baseCmd.replaceFirst('YY', '00'));
          ret['cmd'].add(baseCmd.replaceFirst('YY', '01'));
          break;
        case 'DaytimeStart':
          ret['cmd'].add(baseCmd.replaceFirst('YY', '02'));
          ret['cmd'].add(baseCmd.replaceFirst('YY', '03'));
          break;
        case 'EveningStart':
          ret['cmd'].add(baseCmd.replaceFirst('YY', '04'));
          ret['cmd'].add(baseCmd.replaceFirst('YY', '05'));
          break;
        case 'OvernightStart':
          ret['cmd'].add(baseCmd.replaceFirst('YY', '06'));
          ret['cmd'].add(baseCmd.replaceFirst('YY', '07'));
          break;
      }
    }

    print(cmd);
    return ret;
  }
}