library dslink.mamac.devices;

abstract class MamacDevice {
  String get rootUrl;
  int get refreshRate;
  String get deviceType;
}