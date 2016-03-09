import '../devices.dart';

class SM101 extends MamacDevice {
  static const String type = 'sm101';
  static const String xmlFile = 'sm101.xml';

  @override
  List<LogEntry> logPaths = [
    const LogEntry('Minutes', 'int1.csv'),
    const LogEntry('Hours', 'int2.csv'),
    const LogEntry('Days', 'int3.csv'),
    const LogEntry('Weeks', 'int4.csv'),
    const LogEntry('Months', 'int5.csv'),
  ];

  String get deviceType => type;
  String get fileName => xmlFile;

  // TODO: Verify for this device -- the xml and post document don't make sense
  SM101(DeviceParams deviceParams) : super(deviceParams);

  funt() {
  }
}
