/// Arquivo `taskBoardDatabase.dart` - Contém funções para operações no banco de dados relacionadas a Task Boards.
///
/// Este arquivo fornece funcionalidades para operações como a obtenção do número total de Task Boards,
/// a obtenção do número total de Task Boards associadas a um usuário específico, abertura/criação do banco de dados,
/// consulta de dados de Task Boards, inserção de novas Task Boards, consulta de informações de Task Boards por nome ou usuário,
/// limpeza da tabela de Task Boards, exclusão de todas as Task Boards associadas a um usuário específico e exclusão de uma Task Board pelo ID.
///
/// Todas as funções são assíncronas, refletindo a natureza de operações de banco de dados que podem levar algum tempo para serem concluídas.
///
/// O banco de dados do Task Board possui uma tabela 'task_board' que armazena informações sobre as Task Boards,
/// incluindo id, user_id, name, icon e color.
///
/// O código usa o pacote `sqflite` para interagir com o SQLite, um banco de dados leve embutido em aplicativos Flutter.

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// #### Retorna o número total de TaskBoards no banco de dados.
///
/// Este método consulta o banco de dados para obter a lista de TaskBoards
/// e retorna o número total de TaskBoards armazenadas.
///
/// ### Exemplo de uso:
///
/// ```dart
/// int totalTaskBoards = await tamanho();
/// ```
Future<int> tamanho() async {
  List<Map<String, dynamic>> lista = await consultarDadosTaskBoard();
  int qtdItens = lista.length;

  return qtdItens;
}

/// #### Retorna o número total de TaskBoards associadas a um usuário específico.
///
/// Este método consulta o banco de dados para obter a lista de TaskBoards
/// associadas a um usuário específico e retorna o número total de TaskBoards
/// para esse usuário.
///
/// ### Exemplo de uso:
///
/// ```dart
/// int totalTaskBoardsDoUsuario = await tamanhoByUser(user_id);
/// ```
Future<int> tamanhoByUser(int user_id) async {
  List<Map<String, dynamic>> lista = await getInfoTaskBoardByUser(user_id);
  int qtdItens = lista.length;

  return qtdItens;
}

/// Função assíncrona que abre ou cria um banco de dados SQLite para o task board.
///
/// Retorna um objeto `Database` que representa o banco de dados aberto ou criado.
/// 
/// ### Exemplo de uso:
/// ```dart
/// var taskBoardDatabase = await abrirBancoDeDadosTaskBoard();
/// ```
Future<Database> abrirBancoDeDadosTaskBoard() async {
  var caminho = await getDatabasesPath();
  var caminhoCompleto = join(caminho, 'task_board.db');

  return openDatabase(
    caminhoCompleto,
    version: 1,
    onCreate: (db, versao) {
      return db.execute('''
        CREATE TABLE task_board (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER NOT NULL,
          name VARCHAR NOT NULL,
          icon VARCHAR NOT NULL,
          color INTEGER NOT NULL
        )
      ''');
    },
  );
}

/// Função assíncrona que consulta todos os registros da tabela 'task_board'.
///
/// Retorna uma lista de mapas representando TODOS os registros do banco de dados do task board.
///
/// ### Exemplo de uso:
/// ```dart
/// var dadosTaskBoard = await consultarDadosTaskBoard();
/// ```
Future<List<Map<String, dynamic>>> consultarDadosTaskBoard() async {
  final Database db = await abrirBancoDeDadosTaskBoard();
  return await db.query('task_board');
}

/// Função assíncrona que insere um novo taskboard no banco de dados.
///
/// ### Parâmetros:
///   - `nome`: O nome do board a ser inserido.
///   - `cor`: A cor do board a ser inserida.
///
/// ### Exemplo de uso:
/// ```dart
/// await inserirDadosTaskBoard("Meu Board", 0xFF00FF);
/// ```
Future<void> inserirDadosTaskBoard(String nome, String icone, int user_id, int cor) async {
  final Database db = await abrirBancoDeDadosTaskBoard();

  await db.insert(
    'task_board',
    {
      'name': nome,
      'icon': icone,
      'user_id': user_id,
      'color': cor,
    },
    conflictAlgorithm: ConflictAlgorithm.replace
  );


}

/// Função assíncrona que consulta informações de um board pelo nome.
///
/// ### Parâmetros:
///   - `nome`: O nome do board a ser consultado.
///
/// Retorna uma lista de mapas representando os registros do banco de dados do task board que atendem à consulta.
///
/// ### Exemplo de uso:
/// ```dart
/// var infoBoard = await getInfoTaskBoard("Meu Board");
/// ```
Future<List<Map<String, dynamic>>> getInfoTaskBoard(String nome) async {
  final Database db = await abrirBancoDeDadosTaskBoard();
  List<Map<String, dynamic>> result;

  try {
    result = await db.query(
      'task_board',
      where: 'name = ?',
      whereArgs: [nome],
    );
  } catch (e) {
    result = [];
  }

  return result;
}

Future<List<Map<String, dynamic>>> getInfoTaskBoardByUser(int user_id) async {
  final Database db = await abrirBancoDeDadosTaskBoard();
  List<Map<String, dynamic>> result;

  try {
    result = await db.query(
      'task_board',
      where: 'user_id = ?',
      whereArgs: [user_id],
    );
  } catch (e) {
    result = [];
  }

  return result;
}

/// Função assíncrona que limpa a tabela 'task_board' no banco de dados do task board.
///
/// Exclui todos os registros da tabela 'task_board' e a recria.
///
/// ### Exemplo de uso:
/// ```dart
/// await limparBancoDeDadosTaskBoard();
/// ```
Future<void> limparBancoDeDadosTaskBoard() async {
  final Database db = await abrirBancoDeDadosTaskBoard();

  await db.execute('DROP TABLE IF EXISTS task_board');

  await db.execute('''
    CREATE TABLE task_board (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      name VARCHAR NOT NULL,
      icon VARCHAR NOT NULL,
      color INTEGER NOT NULL
    )
  ''');
}

/// #### Limpa todas as TaskBoards associadas a um usuário específico do banco de dados.
///
/// Este método exclui todas as TaskBoards associadas a um usuário específico
/// do banco de dados. Utiliza a cláusula WHERE para filtrar as TaskBoards
/// associadas ao usuário pelo ID.
///
/// ### Exemplo de uso:
///
/// ```dart
/// await limparBancoDeDadosTaskBoardOfUser(user_id);
/// ```
Future<void> deleteAllTaskBoardsOfUser(int user_id) async {
  final Database db = await abrirBancoDeDadosTaskBoard();

  await db.delete(
    'task_board',
    where: 'user_id = ?',
    whereArgs: [user_id],
  );
}

/// #### Exclui uma TaskBoard do banco de dados pelo ID.
///
/// Este método exclui uma TaskBoard do banco de dados com base no ID especificado.
/// Utiliza a cláusula WHERE para filtrar a TaskBoard pelo ID.
///
/// ### Exemplo de uso:
///
/// ```dart
/// await deleteTaskBoardById(taskBoardId);
/// ```
Future<void> deleteTaskBoardById(int id) async {
  // Abre o banco de dados
  Database db = await abrirBancoDeDadosTaskBoard();

  // Exclui o registro com o ID especificado da tabela task_board
  await db.delete(
    'task_board',
    where: 'id = ?',
    whereArgs: [id],
  );

}
