import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
            email VARCHAR NOT NULL UNIQUE,
            password VARCHAR NOT NULL
          )
        ''');
      },
    );
  }

Future<List<Map<String, dynamic>>> consultarDados() async {
  final Database db = await abrirBancoDeDados();
  return await db.query('user'); // Substitua 'user' pelo nome da sua tabela
}

Future<void> inserirDados(String nome, String email, String senha) async {
  final Database db = await abrirBancoDeDados();

  await db.insert(
    'user', // Nome da tabela
    {
      'name': nome,
      'email': email,
      'password': senha,
    },
    conflictAlgorithm: ConflictAlgorithm.replace
  );

  
}

Future<List<Map<String, dynamic>>> getInfoUser(String email) async {
  // Abre o banco de dados
  final Database db = await abrirBancoDeDados();

  // Lista que irá armazenar o resultado da consulta
  List<Map<String, dynamic>> result;

  try {
    // Consulta o banco de dados para verificar se o e-mail já existe na tabela 'user'
    result = await db.query(
      'user',
      where: 'email = ?', // Condição para a consulta
      whereArgs: [email], // Valor a ser comparado com a condição
    );
  } catch (e) {
    // Trate erros, se houver
    print('Erro ao consultar o banco de dados: $e');
    result = []; // Retorna uma lista vazia em caso de erro
  }

  // Retorna a lista resultante (pode conter 0 ou mais itens)
  return result;
}


Future<void> limparBancoDeDados() async {
  final Database db = await abrirBancoDeDados();

  // Substitua 'user' pelo nome da sua tabela
  await db.execute('DROP TABLE IF EXISTS user');

  // Agora, você pode recriar a tabela usando a mesma lógica do método abrirBancoDeDados
  await db.execute('''
    CREATE TABLE user (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name VARCHAR NOT NULL,
      email VARCHAR NOT NULL UNIQUE,
      password VARCHAR NOT NULL
    )
  ''');
}
