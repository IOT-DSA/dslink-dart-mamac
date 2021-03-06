import 'devices.dart';
import 'mamac_device.dart';

abstract class NodeParser {
  static const String _idPrefix = 'MAV_';

  static const List<String> scheduleHeatCool = const [
    'MorningHeat',
    'MorningCool',
    'DaytimeHeat',
    'DaytimeCool',
    'EveningHeat',
    'EveningCool',
    'OvernightHeat',
    'OvernightCool'
  ];

  static const List<String> scheduleFan = const [
    'MorningFan',
    'DaytimeFan',
    'EveningFan',
    'OvernightFan'
  ];

  static const List<String> scheduleStartEnd = const [
    'MorningStart',
    'DaytimeStart',
    'EveningStart',
    'OvernightStart'
  ];

  static const List<String> weekDays = const [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];

  static Map<String, dynamic> parseNode(String nodeName, dynamic value) {
    var ret = DeviceValue.definition(value);

    var ind = -1;

    if (nodeName.startsWith('RoomTemp')) {
      if (nodeName == 'RoomTempValue') {
        ret[r'$type'] = 'number';
        ret[r'?value'] = num.parse(value);
      }
    } else if ((ind = scheduleHeatCool.indexOf(nodeName)) != -1) {
      ret['@cmdid'] = '${_idPrefix}4X_0$ind';
      ret[r'$type'] = 'number';
    } else if ((ind = scheduleFan.indexOf(nodeName)) != -1) {
      ret['@cmdid'] = '${_idPrefix}3X_0$ind';
      ret[r'$type'] = EnumHelper.enumAutoOn;
      ret[r'?value'] = EnumHelper.AutoOn[int.parse(value)];
    } else if ((ind = scheduleStartEnd.indexOf(nodeName)) != -1) {
      ret['@cmdid'] = '${_idPrefix}2X_YY';
    } else if (weekDays.any((String day) => nodeName.startsWith('${day}_'))) {
      var parts = nodeName.split('_');
      var enabled = parts[1];
      var start = parts[2];
      var stop = parts[3];
      ret = <String, dynamic>{
        'enabled': {
          r'$is': DeviceValue.isType,
          r'$type': 'enum[enabled,disabled]',
          r'$writable': 'write',
          r'?value': enabled,
        },
        'start': {
          r'$is': DeviceValue.isType,
          r'$type': 'string',
          r'$writable': 'write',
          r'?value': start,
        },
        'stop': {
          r'$is': DeviceValue.isType,
          r'$type': 'string',
          r'$writable': 'write',
          r'?value': stop,
        }
      };
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
          ret[r'$editor'] = 'daterange';
          break;
        case 'SystemMode':
          ret['@cmdid'] = '${_idPrefix}70_02';
          ret[r'$type'] = EnumHelper.enumHeatCoolAuto;
          break;
        case 'OverrideMode':
          ret['@cmdid'] = '${_idPrefix}70_05';
          ret[r'$type'] = EnumHelper.enumOffOn;
          break;
        case 'TempUnits':
          ret['@cmdid'] = '${_idPrefix}70_01';
          ret[r'$type'] = 'enum[F,C]';
          break;
        case 'FreezerUnits':
        case 'CoolerUnits':
          ret['@cmdid'] = '${_idPrefix}01_05';
          ret[r'$type'] = 'enum[F,C]';
          break;
        case 'OverrideTime':
          ret['@cmdid'] = '${_idPrefix}70_10';
          ret[r'$type'] = 'number';
          ret[r'$editor'] = 'int';
          ret[r'$min'] = 1;
          ret[r'$max'] = 10;
          ret[r'?value'] = int.parse(value);
          break;
        case 'OverrideHeat':
          ret['@cmdid'] = '${_idPrefix}70_06';
          ret[r'$type'] = 'number';
          ret[r'?value'] = num.parse(value);
          break;
        case 'OverrideCool':
          ret['@cmdid'] = '${_idPrefix}70_07';
          ret[r'$type'] = 'number';
          ret[r'?value'] = num.parse(value);
          break;
        case 'OverrideButton':
          ret['@cmdid'] = '${_idPrefix}70_12';
          ret[r'$type'] = EnumHelper.enumOffOn;
          ret[r'?value'] = EnumHelper.OffOn[int.parse(value)];
          break;
        case 'SetpointDifferential':
          ret['@cmdid'] = '${_idPrefix}70_03';
          ret[r'$type'] = 'number';
          ret[r'$editor'] = 'int';
          ret[r'$max'] = 3;
          ret[r'$min'] = 1;
          ret[r'?value'] = int.parse(value);
          break;
        case 'HeatFanControl':
          ret['@cmdid'] = '${_idPrefix}70_13';
          ret[r'$type'] = EnumHelper.enumOffOn;
          ret[r'?value'] = EnumHelper.OffOn[int.parse(value)];
          break;
        case 'CycleTime':
          ret['@cmdid'] = '${_idPrefix}70_04';
          ret[r'$type'] = 'number';
          ret[r'$editor'] = 'int';
          ret[r'$min'] = 1;
          ret[r'$max'] = 10;
          ret[r'?value'] = int.parse(value);
          break;
        case 'FanOffDelay':
          ret['@cmdid'] = '${_idPrefix}70_08';
          ret[r'$type'] = 'number';
          ret[r'$editor'] = 'int';
          ret[r'$min'] = 1;
          ret[r'$max'] = 10;
          ret[r'?value'] = int.parse(value);
          break;
        case 'MinimumRunTime':
          ret['@cmdid'] = '${_idPrefix}70_09';
          ret[r'$type'] = 'number';
          ret[r'$editor'] = 'int';
          ret[r'$min'] = 1;
          ret[r'$max'] = 10;
          ret[r'?value'] = int.parse(value);
          break;
        case 'Stage2DelayHeat':
          ret['@cmdid'] = '${_idPrefix}70_31';
          ret[r'$type'] = 'number';
          ret[r'$editor'] = 'int';
          ret[r'$min'] = 5;
          ret[r'$max'] = 20;
          ret[r'?value'] = int.parse(value);
          break;
        case 'Stage2DelayCool':
          ret['@cmdid'] = '${_idPrefix}70_34';
          ret[r'$type'] = 'number';
          ret[r'$editor'] = 'int';
          ret[r'$min'] = 5;
          ret[r'$max'] = 20;
          ret[r'?value'] = int.parse(value);
          break;
        case 'Stage2LogicHeat':
          ret['@cmdid'] = '${_idPrefix}70_36';
          ret[r'$type'] = EnumHelper.enumLogicOrAnd;
          ret[r'?value'] = EnumHelper.LogicOrAnd[int.parse(value)];
          break;
        case 'Stage2LogicCool':
          ret['@cmdid'] = '${_idPrefix}70_38';
          ret[r'$type'] = EnumHelper.enumLogicOrAnd;
          ret[r'?value'] = EnumHelper.LogicOrAnd[int.parse(value)];
          break;
        case 'Stage2TurnOnDiffHeat':
          ret['@cmdid'] = '${_idPrefix}70_32';
          ret[r'$type'] = 'number';
          ret[r'$editor'] = 'int';
          ret[r'$min'] = 1;
          ret[r'$max'] = 5;
          ret[r'?value'] = int.parse(value);
          break;
        case 'Stage2TurnOnDiffCool':
          ret['@cmdid'] = '${_idPrefix}70_35';
          ret[r'$type'] = 'number';
          ret[r'$editor'] = 'int';
          ret[r'$min'] = 1;
          ret[r'$max'] = 5;
          ret[r'?value'] = int.parse(value);
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
        case 'ReversingValve':
          ret['@cmdid'] = '${_idPrefix}70_46';
          // TODO: Check what the correct value is
          // The POST document says 1 = Heat, 2 = Cool
          // but the ext xml file shows On/Off.
          ret[r'$type'] = EnumHelper.enumOffOn;
          break;
        case 'AuxHeatValue':
          ret['@cmdid'] = '${_idPrefix}08_00';
          ret[r'$type'] = EnumHelper.enumOffOn;
          break;
        case 'AuxHeatControl':
          ret['@cmdid'] = '${_idPrefix}08_16';
          ret[r'$type'] = EnumHelper.enumAutoManual;
          break;
        case 'OutdoorTempLockoutEnabled':
          ret['@cmdid'] = '${_idPrefix}70_40';
          ret[r'$type'] = EnumHelper.enumDisabledEnabled;
          break;
        case 'OutdoorTempLockoutHeatSetpoint':
          ret['@cmdid'] = '${_idPrefix}70_41';
          ret[r'$type'] = 'number';
          ret['?value'] = num.parse(value);
          break;
        case 'OutdoorTempLockoutCoolSetpoint':
          ret['@cmdid'] = '${_idPrefix}70_42';
          ret[r'$type'] = 'number';
          ret['?value'] = num.parse(value);
          break;
        case 'OutdoorTempAuxHeatLockout':
          ret['@cmdid'] = '${_idPrefix}70_44';
          ret[r'$type'] = 'number';
          ret['?value'] = num.parse(value);
          break;
        // Schedules Special Days
        case 'StartDate':
        case 'EndDate':
          ret['@cmdid'] = '${_idPrefix}XX_YY';
          ret[r'$editor'] = 'daterange';
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
        case 'LowerValue':
          ret['@cmdid'] = '${_idPrefix}01_12';
          ret[r'$type'] = 'number';
          ret[r'?value'] = num.parse(value);
          break;
        case 'UpperValue':
          ret['@cmdid'] = '${_idPrefix}01_13';
          ret[r'$type'] = 'number';
          ret[r'?value'] = num.parse(value);
          break;
        case 'AlertWait':
          ret['@cmdid'] = '${_idPrefix}01_17';
          ret[r'$type'] = 'number';
          ret[r'$editor'] = 'int';
          ret[r'$min'] = 1;
          ret[r'$max'] = 300;
          ret[r'?value'] = int.parse(value);
          break;
        case 'AttachLog':
          ret['@cmdid'] = '${_idPrefix}01_18';
          ret[r'$type'] = EnumHelper.enumOffOn;
          ret[r'?value'] = EnumHelper.OffOn[int.parse(value)];
          break;
        // LOGGING
        case 'LoggingEnabled':
          ret['@cmdid'] = '${_idPrefix}11_01';
          ret[r'$type'] = EnumHelper.enumDisabledEnabled;
          ret['?value'] = EnumHelper.DisabledEnabled[int.parse(value)];
          break;
        case 'LightLog':
          ret['@cmdid'] = '${_idPrefix}1X_01';
          ret[r'$type'] = EnumHelper.enumDisabledEnabled;
          ret['?value'] = EnumHelper.DisabledEnabled[int.parse(value)];
          break;
        case 'LightOutputValue':
          ret['@cmdid'] = '${_idPrefix}0X_00';
          ret[r'$type'] = EnumHelper.enumOffOn;
          ret['?value'] = EnumHelper.OffOn[int.parse(value)];
          break;
        case 'LightOutputControl':
          ret['@cmdid'] = '${_idPrefix}0X_16';
          ret[r'$type'] = EnumHelper.enumAutoManual;
          ret['?value'] = EnumHelper.AutoManual[int.parse(value)];
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
        default:
          ret.remove(r'$writable');
      }
    }

    return ret;
  }

  static Map<String, dynamic> buildSetCommand(DeviceValue node, dynamic value) {
    var ret = {'cmd': null, 'value': null};
    String cmd = node.getAttribute('@cmdid');
    if (cmd == null) return null;
    var nodeName = node.name;

    if (scheduleHeatCool.contains(nodeName)) {
      var parentNames = node.parent.name.split('_');
      if (parentNames.length > 1) {
        var dayInd = EnumHelper.scheduleDays.indexOf(parentNames[1]);
        ret['cmd'] = cmd.replaceFirst('X', '$dayInd');
        ret['value'] = value;
      }
    } else if (scheduleFan.contains(nodeName)) {
      var parentNames = node.parent.name.split('_');
      if (parentNames.length > 1) {
        var dayInd = EnumHelper.scheduleDays.indexOf(parentNames[1]);
        ret['cmd'] = cmd.replaceFirst('X', '$dayInd');
        ret['value'] = EnumHelper.AutoOn.indexOf(value);
      }
    } else if (scheduleStartEnd.contains(nodeName) ||
        nodeName == 'SampleRate') {
      var baseCmd = '';
      if (nodeName == 'SampleRate') {
        baseCmd = cmd;
      } else {
        var parentNames = node.parent.name.split('_');
        if (parentNames.length <= 1) return null;
        var dayInd = EnumHelper.scheduleDays.indexOf(parentNames[1]);
        baseCmd = cmd.replaceFirst('X', '$dayInd');
      }
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
        case 'SampleRate':
          ret['cmd'].add(baseCmd.replaceFirst('YY', '03'));
          ret['cmd'].add(baseCmd.replaceFirst('YY', '04'));
          ret['cmd'].add(baseCmd.replaceFirst('YY', '05'));
          break;
      }
    } else if (['StartDate', 'EndDate'].contains(nodeName)) {
      var parentNames = node.parent.name.split('_');
      if (parentNames.length < 2) return null;
      var dateIdOffset = 49;
      var dateId = int.parse(parentNames[1]) + dateIdOffset;
      var dates = (value as String).split('/').map((el) => DateTime.parse(el));
      var baseCmd = cmd.replaceFirst('XX', '$dateId');
      ret['value'] = [dates[0].month, dates[0].day, dates[0].year % 100];
      switch (nodeName) {
        case 'StartDate':
          ret['cmd'] = [
            baseCmd.replaceFirst('YY', '00'),
            baseCmd.replaceFirst('YY', '01'),
            baseCmd.replaceFirst('YY', '02')
          ];
          break;
        case 'EndDate':
          ret['cmd'] = [
            baseCmd.replaceFirst('YY', '05'),
            baseCmd.replaceFirst('YY', '06'),
            baseCmd.replaceFirst('YY', '07')
          ];
          break;
      }
    } else {
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
        case 'SystemMode':
          ret['cmd'] = cmd;
          ret['value'] = EnumHelper.HeatCoolAuto.indexOf(value);
          break;
        case 'TempUnits':
        case 'CoolerUnits':
        case 'FreezerUnits':
          ret['cmd'] = cmd;
          ret['value'] = value == 'F' ? '1' : '2';
          break;
        case 'DateType':
          ret['cmd'] = cmd;
          ret['value'] = EnumHelper.UnoccupiedOccupied.indexOf(value);
          break;
        case 'OverrideMode':
        case 'HeatFanControl':
        case 'OverrideButton':
        case 'AttachLog':
        case 'FanValue':
        case 'HeatValue':
        case 'Heat2Value':
        case 'CoolValue':
        case 'Cool2Value':
        case 'ReversingValve':
        case 'AuxHeatValue':
          ret['cmd'] = cmd;
          ret['value'] = EnumHelper.OffOn.indexOf(value);
          break;
        case 'FanControl':
        case 'HeatControl':
        case 'Heat2Control':
        case 'CoolControl':
        case 'Cool2Control':
        case 'LightOutputControl':
        case 'AuxHeatControl':
          ret['cmd'] = cmd;
          ret['value'] = EnumHelper.AutoManual.indexOf(value);
          break;
        case 'Stage2LogicHeat':
        case 'Stage2LogicCool':
          ret['cmd'] = cmd;
          ret['value'] = EnumHelper.LogicOrAnd.indexOf(value);
          break;
        case 'AlertEnabled':
        case 'LoggingEnabled':
        case 'OutdoorTempLockoutEnabled':
          ret['cmd'] = cmd;
          ret['value'] = EnumHelper.DisabledEnabled.indexOf(value);
          break;
        case 'LightLog':
          var enumValueFinder = EnumHelper.DisabledEnabled.indexOf;
          getLightNodeValue(node, ret, cmd, value, 0, enumValueFinder);
          break;
        case 'LightOutputValue':
          var enumValueFinder = EnumHelper.OffOn.indexOf;
          getLightNodeValue(node, ret, cmd, value, 5, enumValueFinder);
          break;
        case 'LightOutputControl':
          var enumValueFinder = EnumHelper.AutoManual.indexOf;
          getLightNodeValue(node, ret, cmd, value, 5, enumValueFinder);
          break;
        default:
          ret['cmd'] = cmd;
          ret['value'] = value;
          break;
      }
    }

    return ret;
  }

  static void getLightNodeValue(DeviceValue node, Map ret, String cmd, value,
      int variableOffset, int getIndexOf(String value)) {
    var parentName = node.parent.name;
    var lightRegex = new RegExp(r'Light\d');
    if (lightRegex.hasMatch(parentName)) {
      var lightIndexAsString = parentName.replaceFirst('Light', '');
      var lightIndex = int.parse(lightIndexAsString);
      ret['cmd'] = cmd.replaceFirst('X', '${lightIndex + variableOffset}');
      ret['value'] = getIndexOf(value);
    }
  }
}
