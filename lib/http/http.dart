// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:io';

Future<T> getRequest<T>(String path) async {
  HttpClient client = HttpClient();

  HttpClientRequest request = await client.getUrl(Uri(
    scheme: "https",
    host: "jsonplaceholder.typicode.com",
    path: path,
  ));
  HttpClientResponse response = await request.close();
  String body = await response.transform(utf8.decoder).join();
  T result = json.decode(body);
  return result;
}
