import 'package:test/test.dart';
import 'package:dslink_mamac/src/uri_parser.dart';

main() {
  test('ipv4 address should be parsed', () {
    var result = parseAddress('127.0.0.1');

    expect(result.toString(), 'http://127.0.0.1');
  });

  test('ipv4 with trailing slashes should be parsed', () {
    var result = parseAddress('127.0.0.1/');

    expect(result.toString(), 'http://127.0.0.1');
  });

  test('ipv4 with port should be parsed', () {
    var result = parseAddress('127.0.0.1:8080');

    expect(result.toString(), 'http://127.0.0.1:8080');
  });

  test('http address with port should be parsed', () {
    var result = parseAddress('http://allo.com:8080');

    expect(result.toString(), 'http://allo.com:8080');
  });

  test('http address should be parsed', () {
    var result = parseAddress('http://127.0.0.1');

    expect(result.toString(), 'http://127.0.0.1');
  });

  test('http address with trailing slash should be trimmed', () {
    var result = parseAddress('http://127.0.0.1/');

    expect(result.toString(), 'http://127.0.0.1');
  });

  test('empty string should throw', () {
    var action = () => parseAddress('');

    expect(action, throwsException);
  });
}
