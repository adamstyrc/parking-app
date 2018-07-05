import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:mobileoffice/Models/MonthReservations.dart';

class WebService {

  final API_ADDRESS = 'http://office1.freeworld.cloud/api';
  final HEADERS =  { "Accept": "application/json", "X-Access-Token": "ja" };

  Future<MonthReservations> getParkingMonth(String yearMonth) async {
    final response =
        await http.get(API_ADDRESS + '/parking/' + yearMonth, headers: HEADERS);

    if (response.statusCode == 200) {
      var body = response.body;
      var endIndex = (body.length / 2).toInt();
      var substring = body.substring(0, endIndex);
      var substring2 = body.substring(endIndex, body.length);
      print("BODY:" + substring);
      print(substring2);
      return MonthReservations.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<http.Response> fetchPost() {
    return http.get('https://jsonplaceholder.typicode.com/posts/1');
  }
}