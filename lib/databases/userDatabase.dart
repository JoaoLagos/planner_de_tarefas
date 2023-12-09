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

Future<bool> emailExists(String email) async {
  final Database db = await abrirBancoDeDados();

  // Consultar o banco de dados para verificar se o e-mail já existe
  List<Map<String, dynamic>> result = await db.query(
    'user',
    where: 'email = ?',
    whereArgs: [email],
  );

  // Se a lista resultante tiver algum item, significa que o e-mail já existe
  return result.isNotEmpty;
}