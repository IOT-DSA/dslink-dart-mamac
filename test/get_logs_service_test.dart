import 'package:test/test.dart';
import 'package:dslink_mamac/services.dart';
import 'package:dslink_mamac/mamac_nodes.dart';

main() {
  var sut = new GetLogsService();

  var params = new DeviceParams()
    ..address = '141.140.246.1'
    ..type = 'sm101'
    ..refreshRate = 0;

  var device = new MamacDevice.fromParams(params);

  test('should return a csv string', () async {
    var randomLogEntry = device.logPaths[0];

    var result = await sut.fetchCsvLogs(device, randomLogEntry);

    expect(result, (r) => r is String);
  });
}
