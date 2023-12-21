/// Arquivo `userDatabase.dart` - Contém funções para operações no banco de dados relacionadas a usuários.
///
/// Este arquivo fornece funcionalidades como a abertura/criação do banco de dados, consulta de dados de usuários,
/// inserção de novos usuários, consulta de informações de usuários por e-mail ou ID, e limpeza da tabela de usuários.
///
/// Todas as funções são assíncronas, refletindo a natureza de operações de banco de dados que podem levar algum tempo para serem concluídas.
///
/// O banco de dados possui uma tabela 'user' que armazena informações sobre os usuários, incluindo id, nome, e-mail e senha.
/// O código usa o pacote `sqflite` para interagir com o SQLite, um banco de dados leve embutido em aplicativos Flutter.

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Função assíncrona que abre ou cria um banco de dados SQLite.
///
/// Retorna um objeto `Database` que representa o banco de dados aberto ou criado.
/// 
/// ### Exemplo de uso:
/// ```dart
/// var database = await abrirBancoDeDados();
/// ```
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
            password VARCHAR NOT NULL,
            lista_tarefas LIST
          )
        ''');
      },
    );
  }

/// Função assíncrona que consulta todos os registros da tabela 'user'.
///
/// Retorna uma lista de mapas representando TODOS os registros do banco de dados.
///
/// ### Exemplo de uso:
/// ```dart
/// var dados = await consultarDados();
/// ```
Future<List<Map<String, dynamic>>> consultarDados() async {
  final Database db = await abrirBancoDeDados();
  return await db.query('user');
}

/// Função assíncrona que insere um novo usuário no banco de dados.
///
/// ### Parâmetros:
///   - `nome`: O nome do usuário a ser inserido.
///   - `email`: O endereço de e-mail do usuário a ser inserido.
///   - `senha`: A senha do usuário a ser inserida.
///
/// ### Exemplo de uso:
/// ```dart
/// await inserirDados("João", "joao@email.com", "senha123");
/// ```
Future<void> inserirDados(String nome, String email, String senha) async {
  final Database db = await abrirBancoDeDados();

  await db.insert(
    'user',
    {
      'name': nome,
      'email': email,
      'password': senha,
    },
    conflictAlgorithm: ConflictAlgorithm.replace
  );

  
}

/// Função assíncrona que consulta informações de um usuário pelo endereço de e-mail.
///
/// ### Parâmetros:
///   - `email`: O endereço de e-mail do usuário a ser consultado.
///
/// Retorna uma lista de mapas representando os registros do banco de dados que atendem à consulta.
///
/// ### Exemplo de uso:
/// ```dart
/// var infoUsuario = await getInfoUser("joao@email.com");
/// ```
Future<List<Map<String, dynamic>>> getInfoUser(String email) async {
  final Database db = await abrirBancoDeDados();

  List<Map<String, dynamic>> result;

  try {
    result = await db.query(
      'user',
      where: 'email = ?', 
      whereArgs: [email], 
    );
  } catch (e) {
    
    result = []; 
  }

  return result;
}

Future<List<Map<String, dynamic>>> getInfoUserById(int user_id) async {
  final Database db = await abrirBancoDeDados();

  List<Map<String, dynamic>> result;

  try {
    result = await db.query(
      'user',
      where: 'id = ?', 
      whereArgs: [user_id], 
    );
  } catch (e) {
    result = []; 
  }

  return result;
}

/// Função assíncrona que limpa a tabela 'user' no banco de dados.
///
/// Exclui todos os registros da tabela 'user' e a recria.
///
/// ### Exemplo de uso:
/// ```dart
/// await limparBancoDeDados();
/// ```
Future<void> limparBancoDeDados() async {
  final Database db = await abrirBancoDeDados();

  await db.execute('DROP TABLE IF EXISTS user');

  await db.execute('''
    CREATE TABLE user (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name VARCHAR NOT NULL,
      email VARCHAR NOT NULL UNIQUE,
      password VARCHAR NOT NULL
    )
  ''');
}
