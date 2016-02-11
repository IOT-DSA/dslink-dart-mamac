library dslink.mamac.nodes.devices.mt201;

import 'devices.dart';
import '../mamac_client.dart';

class MT201 extends MamacDevice {
  static const String type = 'mt201';
  static const String xmlFile = 'mt201ext.xml';

  String get deviceType => type;
  String get fileName => xmlFile;

  MT201(String address, int refreshRate) : super(address, refreshRate);
}