import '../devices.dart';

class MT201 extends MamacDevice {
  static const String type = 'mt201';
  static const String xmlFile = 'mt201ext.xml';

  @override
  List<LogEntry> logPaths = [const LogEntry('Room Temp', 'ch1.csv')];

  String get deviceType => type;
  String get fileName => xmlFile;

  MT201(DeviceParams deviceParams) : super(deviceParams);
}
