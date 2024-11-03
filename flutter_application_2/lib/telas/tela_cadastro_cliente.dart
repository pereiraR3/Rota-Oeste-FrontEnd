import 'package:flutter/material.dart';
import 'package:flutter_application_2/componentes/side_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TelaCadastroCliente extends StatefulWidget {
  final String token;

  const TelaCadastroCliente({super.key, required this.token});

  @override
  State<TelaCadastroCliente> createState() => _TelaCadastroClienteState();
}

class _TelaCadastroClienteState extends State<TelaCadastroCliente> {
  late TextEditingController _nomeController;
  late TextEditingController _telefoneController;

  String? token;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController();
    _telefoneController = TextEditingController();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token') ?? widget.token;
    });
    print('Token carregado para requisição: $token');
  }

  Future<void> CriarCliente() async {
    try {
      // Fazendo a requisição HTTP POST
      final response = await http.post(
        Uri.parse('http://localhost:5092/cliente/adicionar'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "usuarioId": 2,
          "nome": _nomeController.text,
          "telefone": _telefoneController.text,
          "foto": "null"
        }),
      );

      // Verificando o código de status da resposta
      if (response.statusCode >= 200 && response.statusCode < 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Sucesso'), backgroundColor: Color(0xFF32A869)),
        );
      } else if (response.statusCode >= 400) {
        final data = jsonDecode(response.body);
        var e = data['message'] ?? 'Erro desconhecido';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro checklista: $e'),
            backgroundColor: Color.fromARGB(255, 168, 87, 50),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Erro ao se conectar com o servidor: $e',
                style: TextStyle(color: Colors.black)),
            backgroundColor: Color.fromRGBO(240, 231, 16, 80)),
      );
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Row(
        children: [
          SideBar(token: token ?? ''), // Passando o token para a SideBar
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 600,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color.fromRGBO(117, 117, 117, 1),
                    ),
                    child: Center(
                      child: Text(
                        'Cadastro de Contatos',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Container(
                    padding: EdgeInsets.all(20),
                    width: screenSize.width * 0.8,
                    height: screenSize.height * 0.6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color.fromRGBO(117, 117, 117, 1),
                    ),
                    child: Column(
                      children: [
                        Container(
                          
                          padding: EdgeInsets.all(5),
                          child: Text(
                            "Nome:",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 600,
                          child: TextField(
                            controller: _nomeController,
                            decoration: InputDecoration(
                            
                              filled: true,
                              fillColor: const Color.fromRGBO(240, 231, 16, 80),
                              hintText: "Digite o nome",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            "Numero:",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 600,
                          child: TextField(
                            controller: _telefoneController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color.fromRGBO(240, 231, 16, 80),
                              hintText: "Digite o numero",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed:
                              CriarCliente, // Chama a função CriarCliente
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Color.fromRGBO(240, 231, 16, 1)),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.black),
                            fixedSize: MaterialStateProperty.all(Size(140, 50)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          child: Text("Cadastrar"),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
