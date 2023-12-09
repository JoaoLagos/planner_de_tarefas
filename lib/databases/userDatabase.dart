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
            password VARCHAR NOT NULL
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
  return await db.query('user'); // Substitua 'user' pelo nome da sua tabela
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
    'user', // Nome da tabela
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
