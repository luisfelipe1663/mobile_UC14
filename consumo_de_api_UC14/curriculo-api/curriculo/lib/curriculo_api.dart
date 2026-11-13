//biblioteca que permite converter dados entre diferentes formatos
//converter JSON em objeto dart
import 'dart:convert';

//importa o pacote http
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CurriculoApi {
  final String baseUrl;
  const CurriculoApi(this.baseUrl);

//Future indica que o metodo retornará um resultado futuramente, isso ocorre porque a comunicação com a API é assincrona 
  Future<Map<String,dynamic>> buscarCurriculo(int id) async{
    final uri = Uri.parse('$baseUrl/api/curriculos/$id');

    try{
      final resposta = await http.get(uri).timeout(
        const Duration(seconds: 10)
      );
      if(resposta.statusCode == 200){
        final dados = jsonDecode(resposta.body);
        if(dados is Map<String,dynamic>){
          return dados;
        };
        throw Exception('Formato de JSON inválido');
      }
      if(resposta.statusCode == 404){
        throw Exception('Curriculo não encontrado');
      }
      throw Exception('Erro Http:${resposta.statusCode}');
    }catch(erro){
      throw Exception('Erro ao consultar API: $erro');
    }
  }
}
