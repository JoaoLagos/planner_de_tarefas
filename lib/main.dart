import 'package:flutter/material.dart';
import 'screens/login.dart';

void main() async {
  // Inicializa o banco de dados antes de iniciar o aplicativo
  

  runApp( const MaterialApp(
    title: "Planner de Tarefas",
    debugShowCheckedModeBanner: false,
    
    home: Login(),
  ));
}


