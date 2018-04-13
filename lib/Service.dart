
import 'Models/Month.dart';
import 'package:json/json.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:io';

class Service {
  static final _singleton = new Service._internal();
  static final baseURL = "https://mobileoffice-api-poc.azurewebsites.net/ms-parkApp-0.0.1-SNAPSHOT/";

  factory Service() {
    return _singleton;
  }

  Service._internal();

  void update() {
    var yearString = "2018";
    var monthString = "03";
    var url = baseURL + "parking/\(yearString)-\(monthString)-01";

    print(url);

    var httpClient = new HttpClient();
    var uri = new Uri.https('api.github.com', '/users/1');
    
    var t = httpClient.get("api", 80, "/users/1");
    t.then((value) =>
     print(value) 
    );
    //var request = await httpClient.getUrl(uri);
    //var response = await request.close();
    //var responseBody = await response.transform(UTF8.decoder).join();
    //return responseBody;
  }
}