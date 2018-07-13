import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobileoffice/Logger.dart';
import 'package:mobileoffice/Models/AccessToken.dart';
import 'package:mobileoffice/Models/MonthReservations.dart';
import 'package:mobileoffice/UserController.dart';

class WebService {

  final API_ADDRESS = 'http://office1.freeworld.cloud/api';
  final STATIC_HEADERS =  { "Accept": "application/json", "Content-Type": "application/json" };

  Future<MonthReservations> getParkingMonth(String yearMonth) async {
    final response =
        await http.get(API_ADDRESS + '/calendar/' + yearMonth, headers: await prepareHeaders());

    if (response.statusCode == 200) {
      var body = response.body;
      Logger.log("BODY: " + body);
      return MonthReservations.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<Map<String, String>> prepareHeaders() async {
    var headers = Map.of(STATIC_HEADERS);
    var accessToken = await UserController.get().getAccessToken();
    if (accessToken != null) {
      headers["X-Access-Token"] =  accessToken;
    }

    return headers;
  }

  Future<void> postParking(String date) async {
    final response =
        await http.post(API_ADDRESS + '/calendar/$date/reservation', headers: await prepareHeaders());

    if (isResponseSuccessful(response)) {
      Logger.log("BODY: " + response.body);
      return response;
    } else {
      throw Exception('Failed request');
    }
  }

  Future<void> deleteParking(String date) async {
    final response =
    await http.delete(API_ADDRESS + '/calendar/$date/reservation', headers: await prepareHeaders());

    if (isResponseSuccessful(response)) {
      Logger.log("BODY: " + response.body);
      return response;
    } else {
      throw Exception('Failed request');
    }
  }

  Future<http.Response> fetchPost() {
    return http.get('https://jsonplaceholder.typicode.com/posts/1');
  }

  Future<void> postFirebaseToken(String token) async {
    Map<String, dynamic> bodyMap = {
      'token': token,
      'platform': 'android',
    };

    final response = await  http.post(API_ADDRESS + '/users/me/notifiers', body: json.encode(bodyMap),headers: await prepareHeaders());

    Logger.log("BODY: " + response.body);
    if (isResponseSuccessful(response)) {
      return;
    } else {
      throw Exception('Could not register push token');
    }
  }

  Future<AccessToken> postAuth(String email, String password) async {
    Map<String, dynamic> bodyMap = {
      'email': email,
      'password': password,
    };

    final response =
      await http.post(API_ADDRESS + '/auth', headers: await prepareHeaders(), body: json.encode(bodyMap));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      Logger.log(response.body);

      return AccessToken.fromJson(json.decode(response.body));
    } else {
      throw Exception('failure');
    }
  }

  bool isResponseSuccessful(http.Response response) {
    return response.statusCode >= 200 && response.statusCode < 300;
  }
}