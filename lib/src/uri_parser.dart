Uri parseAddress(String address) {
  Uri parsed;

  String trimTrailingSlashes(String s) {
    if (s == '/') {
      return '';
    } else if (s.endsWith('/')) {
      return trimTrailingSlashes(s.substring(0, s.length - 1));
    } else {
      return s;
    }
  }

  String sanitizedAddress = trimTrailingSlashes(address);

  try {
    parsed = Uri.parse(sanitizedAddress);

    if (parsed.scheme.isEmpty) {
      parsed = new Uri.http(parsed.toString(), '');
    }
  } on FormatException {
    parsed = Uri.parse('http://${sanitizedAddress}');
  }

  return parsed;
}
