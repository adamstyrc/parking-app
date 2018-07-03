import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mobileoffice/Models/MonthReservations.dart';

class WebService {

  Future<MonthReservations> getParkingMonth(String yearMonth) async {
    final response =
        await http.get('http://office.freeworld.cloud/api/parking/' + yearMonth, headers: { "Accept": "application/json", "X-Access-Token": "ja" });

    if (response.statusCode == 200) {
      return MonthReservations.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<http.Response> fetchPost() {
    return http.get('https://jsonplaceholder.typicode.com/posts/1');
  }
}