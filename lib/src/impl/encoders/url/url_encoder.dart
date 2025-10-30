String decodeUrl(String content) {
  return Uri.decodeComponent(content);
}

String encodeUrl(String content) {
  return Uri.encodeComponent(content);
}
