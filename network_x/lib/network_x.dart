library;

import 'package:http/http.dart' as http;

const headerIfModifiedSince = "If-Modified-Since";
const headerLastModified = "Last-Modified";
const headerContentType = "Content-Type";
const headerAuthorization = "Authorization";

mixin DomainConfig {
  static String defaultScheme = 'https';

  String get scheme => defaultScheme;

  String get domain;

  String get urlScheme => scheme;

  String get urlDomain => '$urlScheme://$domain';
}

extension ResponseX on http.Response {
  bool get isSuccessful => statusCode >= 200 && statusCode <= 299;

  bool get isServerError => statusCode >= 500 && statusCode <= 599;
}
