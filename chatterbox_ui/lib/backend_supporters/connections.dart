import 'package:http/http.dart';
import 'dart:convert';

// const BASE_URI = 'http://127.0.0.1:5000/user';
const host = '192.168.1.36';

Future<int> newUserRegister(String username, String password) async {
  Uri uri = Uri(scheme: 'http', host: host, path: '/user', port: 5000);

  Response response = await post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(<String, String>{
      'username': username,
      'password': password,
    }),
  );
  return response.statusCode;
}

Future<List<String>> userLogin(String username, String password) async {
  Uri uri = Uri(scheme: 'http', host: host, path: '/user', port: 5000);

  Response response = await put(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(<String, String>{
      'username': username,
      'password': password,
    }),
  );

  return [response.statusCode.toString(), response.body];
}
