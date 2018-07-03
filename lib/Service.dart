
import 'Models/Month.dart';
import 'package:json/json.dart';
//import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'Models/User.dart';
import 'dart:convert';
import 'package:rxdart/rxdart.dart';
import 'Utils/Variable.dart';

class Service {
  static final _singleton = new Service._internal();
  static final baseURL = "https://mobileoffice-api-poc.azurewebsites.net/ms-parkApp-0.0.1-SNAPSHOT/";

  factory Service() {
    return _singleton;
  }

  var loggedUser = Variable<User>(null);

  Service._internal();

  void updateOld() {
    var yearString = "2018";
    var monthString = "03";
    var url = baseURL + "parking/$yearString-$monthString-01";

    print(url);
    
    var httpClient = new HttpClient();
    //var uri = new Uri.https('api.github.com', '/users/1');

    var request = httpClient.get("office.freeworld.cloud", 80, "/user");
        
    
    request.then((value) =>
     print(value) 
    );
    //var request = await httpClient.getUrl(uri);
    //var response = await request.close();
    //var responseBody = await response.transform(UTF8.decoder).join();
    //return responseBody;
  }

  void login(String login, String password) {
    this.loggedUser.value = null;
  }

  Variable <Month> getMonth(int month, int year) {
    var month = Month.fromJson({});
    return Variable(month); 
  }

  void update() {
    new http.Client()
   .get(
     "http://office.freeworld.cloud/user",
     headers: {
       'Content-type': 'application/json',
       'email': 'artur.gurgul@vattenfall.com',
       'Authorization': 'token'
     },
     //body: '{"distinct": "users","key": "account","query": {"active":true}}'
     )
   .whenComplete(() => print('completed'))
   .then((http.Response r) => r.body)
   .then((body) =>
      User.fromJson(JSON.decode(body))
   )
   .then((user) => this.loggedUser.value = user)
   ;
  }

  
}