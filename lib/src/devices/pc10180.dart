import '../devices.dart';

class PC10180 extends MamacDevice {
  static const String type = 'pc10180';
  static const String xmlFile = 'pc10180.xml';

  @override
  List<LogEntry> logPaths = [
    const LogEntry('Input 1', 'ch1.csv'),
    const LogEntry('Input 2', 'ch2.csv'),
    const LogEntry('Input 3', 'ch3.csv'),
    const LogEntry('Input 4', 'ch4.csv'),
    const LogEntry('Input 5', 'ch5.csv'),
    const LogEntry('Input 6', 'ch6.csv'),
    const LogEntry('Input 7', 'ch7.csv'),
    const LogEntry('Input 8', 'ch8.csv'),
  ];

  String get deviceType => type;
  String get fileName => xmlFile;

  // TODO: Check for this device
  // The POST document doesn't fit with the xml file.
  PC10180(DeviceParams deviceParams) : super(deviceParams);
}
