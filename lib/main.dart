import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'databases/userDatabase.dart' as user_database;

void main() async {
  // Inicializa o banco de dados antes de iniciar o aplicativo
  var dbUsuarios = user_database.abrirBancoDeDados();

  runApp( MaterialApp(
    title: "Planner de Tarefas",
    debugShowCheckedModeBanner: false,
    home: Login(bancoDeDados: dbUsuarios,),
  ));
}


