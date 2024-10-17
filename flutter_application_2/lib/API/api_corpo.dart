import 'dart:convert';

import 'package:flutter_application_2/models/cliente.dart';
import 'package:http/http.dart' as http;
class ApiCorpo {
  final String baseUri = "https://run.mocky.io/v3/00ba1a0f-47eb-4afa-93f6-b970ab8ddba3";

  Future<List<Cliente>> getClienteData() async{
  List<Cliente> data =  [];
  final uri = Uri.parse(baseUri) ;
  try{
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-type' : 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode >= 200 && response.statusCode <= 299){
      final List<dynamic> jsonData = json.decode(response.body);
      data = jsonData.map((json) => Cliente.fromJson(json)).toList();
    }
  }catch(e){
    return data;
  }
  return data;
  }
}