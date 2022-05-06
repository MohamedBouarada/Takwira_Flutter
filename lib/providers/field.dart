// ignore_for_file: avoid_print, prefer_final_fields

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/field_model.dart';
import "../models/http_exception.dart";

class Field with ChangeNotifier {
  static List<FieldModel> _items = [];

  List<FieldModel> get items {
    return [..._items];
  }
  
  FieldModel findById(int id) {
    return _items.firstWhere((field) => field.id == id);
  }

  Future<List<FieldModel>> getFields() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = "http://10.0.2.2:5000/field/getByOwner/1";
    print(url);
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: requestHeaders,
      );
      final extractedData = json.decode(response.body) as List;
      // ignore: unnecessary_null_comparison
      if (extractedData == null) {
        return [];
      }

      final List<FieldModel> loadedProducts = [];

      for (var i = 0; i < extractedData.length; i++) {
        loadedProducts.add(FieldModel(
          id: extractedData[i]['id'],
          name: extractedData[i]['name'],
          adresse: extractedData[i]['adresse'],
          type: extractedData[i]['type'],
          services: extractedData[i]['services'],
          price: extractedData[i]['price'],
          description: extractedData[i]['description'],
          idProprietaire: extractedData[i]['idProprietaire'],
          isNotAvailable: extractedData[i]['isNotAvailable'],
          surface: extractedData[i]['surface'],
          period: extractedData[i]['period'],
        ));
      }
      _items = loadedProducts;
      print(_items);
      return loadedProducts;
    } catch (error) {
      rethrow;
    }
  }
  
  Future<List> get() async {
    var url = "http://10.0.2.2:5000/field/getByOwner/1";
    var response = await http.get(
      Uri.parse(url),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );

    // print(response.body);
    if (response.statusCode == 200) {
      print(json.decode(response.body));
      return json.decode(response.body);
    }
    return [];
  }

  Future<void> add({
    required String name,
    required String adresse,
    required String type,
    required Map<String, dynamic> isNotAvailable,
    required String services,
    required double price,
    required String period,
    required String surface,
    required String description,
    required int idProprietaire,
  }) async {
    const url = 'http://10.0.2.2:5000/field/add';
    print(url);
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: json.encode(
          {
            'name': name,
            'adresse': adresse,
            'type': type,
            'isNotAvailable': isNotAvailable,
            'services': services,
            'prix': price,
            'period': period,
            'surface': surface,
            'description': description,
            'idProprietaire': 1,
          },
        ),
      );
      final responseData = json.decode(response.body);
      print(responseData);
      if (response.statusCode != HttpStatus.created) {
        throw HttpException(responseData);
      }
      notifyListeners();
    } catch (error) {
      print("**************");
      print(error.toString());
      rethrow;
    }
  }

  Future<void> update({
    required int id,
    required String name,
    required String adresse,
    required String type,
    required Map<String, dynamic> isNotAvailable,
    required String services,
    required double price,
    required String period,
    required String surface,
    required String description,
    required int idProprietaire,
  }) async {
    var url = 'http://10.0.2.2:5000/field/' + id.toString();
    print(url);
    try {
      print(type);

      final response = await http.put(
        Uri.parse(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: json.encode(
          {
            'name': name,
            'adresse': adresse,
            'type': type,
            'isNotAvailable': isNotAvailable,
            'services': services,
            'prix': price,
            'period': period,
            'surface': surface,
            'description': description,
            'idProprietaire': 1,
          },
        ),
      );
      final responseData = json.decode(response.body);
      print(responseData);
      if (response.statusCode != HttpStatus.created) {
        throw HttpException(responseData);
      }
      notifyListeners();
    } catch (error) {
      print("**************");
      print(error.toString());
      rethrow;
    }
  }

  Future<void> deleteField(int id) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = 'http://10.0.2.2:5000/field/' + id.toString();

    final response = await http.delete(
      Uri.parse(url),
      headers: requestHeaders,
    );
    notifyListeners();
    print(json.decode(response.body));
    if (response.statusCode >= 400) {
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
  }

  
  final _fieldType = [
    {'display': "Tennis", 'value': "TENNIS"},
    {'display': "Football", 'value': 'FOOTBALL'},
    {'display': "Golf", 'value': 'GOLF'},
    {'display': "Bascketball", 'value': 'BASCKETBALL'},
  ];
  List<Map<String, String>> get fieldType {
    return [..._fieldType];
  }

  final _tennisSurfaceTypes = [
    {'display': "GREEN SET", 'value': "GREEN SET"},
    {'display': "RESIN", 'value': 'RESIN'},
    {'display': "GAZON HYBRIDE", 'value': 'GAZON HYBRIDE'},
    {'display': "TERRE BATTUE", 'value': 'TERRE BATTUE'},
  ];
  List<Map<String, String>> get tennisSurfaceTypes {
    return [..._tennisSurfaceTypes];
  }

  final _footSurfaceTypes = [
    {'display': "NATURAL GRASS", 'value': "NATURAL GRASS"},
    {'display': "ARTIFICIAL SURFACE", 'value': "ARTIFICIAL SURFACE"},
    {'display': "HYBRID TURF", 'value': "HYBRID TURF"},
  ];
  List<Map<String, String>> get footSurfaceTypes {
    return [..._footSurfaceTypes];
  }
}