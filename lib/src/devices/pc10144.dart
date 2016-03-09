import '../devices.dart';

class PC10144 extends MamacDevice {
  static const String type = 'pc10144';
  static const String xmlFile = 'pc10144.xml';

  @override
  List<LogEntry> logPaths = [
    const LogEntry('Input 1', 'ch1.csv'),
    const LogEntry('Input 2', 'ch2.csv'),
    const LogEntry('Input 3', 'ch3.csv'),
    const LogEntry('Input 4', 'ch4.csv'),
  ];

  String get deviceType => type;
  String get fileName => xmlFile;

  // TODO: Check for this device
  // The POST document doesn't fit with the xml file.
  PC10144(DeviceParams deviceParams) : super(deviceParams);
}
