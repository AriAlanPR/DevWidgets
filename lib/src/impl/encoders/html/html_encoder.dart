import 'dart:convert';
import 'package:html_unescape/html_unescape_small.dart';

String decodeHtml(String content) {
  var unescape = HtmlUnescape();

  return unescape.convert(content);
}

String encodeHtml(String content) {
  const htmlEscape = HtmlEscape();
  return htmlEscape.convert(content);
}
