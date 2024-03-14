import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:leap_flutter/models/Profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/ServiceCountResponse.dart';

class SharedPrefObj {

  // clear all saved details
  static Future<void> clearAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }



  /***  Set and Get Token  ***/
  static Future<String?> getSharedPrefValue(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> setSharedPrefValue(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }


  /***  Set and Get User Profile Details  ***/
  static Future<Profile?> getProfileSharedPreValue(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(key);
    if(jsonString != null) {
      //Convert json string to map
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      // create model from Map
      return Profile.fromJson(jsonMap);
    }
  }

  static Future<void> setProfileSharedPreValue(String key, Profile value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //convert model to json string
    final String jsonString = json.encode(value.toJson());
    await prefs.setString(key, jsonString);
  }

  /***  homw service count set get  ***/
  static Future<ServiceCountResponse?> getServiceCountSharedPreValue(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(key);
    if(jsonString != null) {
      //Convert json string to map
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      // create model from Map
      return ServiceCountResponse.fromJson(jsonMap);
    }
  }

  static Future<void> setServiceCountSharedPreValue(String key, ServiceCountResponse value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //convert model to json string
    final String jsonString = json.encode(value.toJson());
    await prefs.setString(key, jsonString);
  }

}
