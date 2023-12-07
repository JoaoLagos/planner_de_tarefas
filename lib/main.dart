import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'screens/login.dart';

void main() async {
  // Inicializa o banco de dados antes de iniciar o aplicativo
  var dbUsuarios = abrirBancoDeDados();

  runApp( MaterialApp(
    title: "Planner de Tarefas",
    debugShowCheckedModeBanner: false,
    home: Login(bancoDeDados: dbUsuarios,),
  ));
}

Future<Database> abrirBancoDeDados() async {
  var caminho = await getDatabasesPath();
  var caminhoCompleto = join(caminho, 'meu_banco.db');

  return openDatabase(
    caminhoCompleto,
    version: 1,
    onCreate: (db, versao) {
      return db.execute('''
        CREATE TABLE user (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name VARCHAR NOT NULL,
          email VARCHAR NOT NULL,
          password VARCHAR NOT NULL
        )
      ''');
    },
  );
}
