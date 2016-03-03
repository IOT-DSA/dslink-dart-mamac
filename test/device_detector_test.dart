import 'package:test/test.dart';
import 'package:dslink_mamac/mamac_nodes.dart';

main() {
  var detector = new DeviceTypeDetector();
  test('sm-101 is detected', () async {
    var type = await detector.findType(new Uri.http('141.140.246.1', ''));

    expect(type, SM101.type);
  });

  test('pc10144 is detected', () async {
    var type = await detector.findType(new Uri.http('50.241.43.58:9005', ''));

    expect(type, PC10144.type);
  });

  test('mt201 is detected', () async {
    var type = await detector.findType(new Uri.http('50.194.207.81', ''));

    expect(type, MT201.type);
  });

  test('pc10180 is detected', () async {
    var type =
        await detector.findType(new Uri.http('173.15.237.222:30000', ''));

    expect(type, PC10180.type);
  });

  test('wrong address should throw', () async {
    var action = () => detector.findType(new Uri.http('google.com', ''));

    expect(action(), throwsException);
  });
}
