library;

import 'dart:convert';

import 'package:http/http.dart' as http;

const headerIfModifiedSince = "If-Modified-Since";
const headerLastModified = "Last-Modified";
const headerContentType = "Content-Type";
const headerAuthorization = "Authorization";

mixin DomainConfig {
  static const String defaultScheme = 'https';

  String get scheme => defaultScheme;

  String get domain;

  String get urlScheme => scheme;

  String get urlDomain => '$urlScheme://$domain';
}

extension RequestX on http.Request {
  set jsonBody(Object bodyData) {
    headers['Content-Type'] = 'application/json';
    body = jsonEncode(bodyData);
  }
}

extension ResponseX on http.Response {
  bool get isSuccessful => statusCode >= 200 && statusCode <= 299;

  bool get isServerError => statusCode >= 500 && statusCode <= 599;
}
