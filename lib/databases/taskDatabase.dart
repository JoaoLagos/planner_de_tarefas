import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Função assíncrona que abre ou cria um banco de dados SQLite para as tarefas.
///
/// Retorna um objeto `Database` que representa o banco de dados aberto ou criado.
/// 
/// ### Exemplo de uso:
/// ```dart
/// var taskDatabase = await abrirBancoDeDadosTask();
/// ```
Future<Database> abrirBancoDeDadosTask() async {
  var caminho = await getDatabasesPath();
  var caminhoCompleto = join(caminho, 'task.db');

  return openDatabase(
    caminhoCompleto,
    version: 1,
    onCreate: (db, versao) {
      return db.execute('''
        CREATE TABLE task (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER NOT NULL,
          board_id INTEGER NOT NULL,
          title VARCHAR NOT NULL,
          note TEXT NOT NULL,
          date VARCHAR NOT NULL,
          startTime VARCHAR NOT NULL,
          endTime VARCHAR NOT NULL,
          isCompleted INTEGER,
          FOREIGN KEY(user_id) REFERENCES user(id),
          FOREIGN KEY(board_id) REFERENCES task_board(id)
        )
      ''');
    },
  );
}

/// Função assíncrona que consulta todas as tarefas da tabela 'task'.
///
/// Retorna uma lista de mapas representando TODOS os registros do banco de dados de tarefas.
///
/// ### Exemplo de uso:
/// ```dart
/// var dadosTarefas = await consultarDadosTask();
/// ```
Future<List<Map<String, dynamic>>> consultarDadosTask() async {
  final Database db = await abrirBancoDeDadosTask();
  return await db.query('task'); // Substitua 'task' pelo nome da sua tabela de tarefas
}

/// Função assíncrona que insere uma nova tarefa no banco de dados.
///
/// ### Parâmetros:
///   - `userId`: O ID do usuário associado à tarefa.
///   - `boardId`: O ID do board associado à tarefa.
///   - `titulo`: O título da tarefa a ser inserido.
///   - `nota`: A nota da tarefa a ser inserida.
///   - `data`: A data da tarefa a ser inserida.
///   - `horaInicio`: A hora de início da tarefa a ser inserida.
///   - `horaFim`: A hora de término da tarefa a ser inserida.
///   - `estaCompleta`: Um indicador se a tarefa está completa ou não.
///
/// ### Exemplo de uso:
/// ```dart
/// await inserirDadosTask(1, 1, "Fazer compras", "Comprar leite e ovos", "2023-12-31", "08:00", "09:00", 0);
/// ```
Future<void> inserirDadosTask(
    int userId,
    int boardId,
    String titulo,
    String nota,
    String data,
    String horaInicio,
    String horaFim,
    int estaCompleta,
  ) async {
  final Database db = await abrirBancoDeDadosTask();

  await db.insert(
    'task',
    {
      'user_id': userId,
      'board_id': boardId,
      'title': titulo,
      'note': nota,
      'date': data,
      'startTime': horaInicio,
      'endTime': horaFim,
      'isCompleted': estaCompleta,
    },
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

/// Função assíncrona que consulta informações de uma tarefa pelo título.
///
/// ### Parâmetros:
///   - `titulo`: O título da tarefa a ser consultada.
///
/// Retorna uma lista de mapas representando os registros do banco de dados de tarefas que atendem à consulta.
///
/// ### Exemplo de uso:
/// ```dart
/// var infoTarefa = await getInfoTask("Fazer compras");
/// ```
Future<List<Map<String, dynamic>>> getInfoTask(String titulo) async {
  final Database db = await abrirBancoDeDadosTask();
  List<Map<String, dynamic>> result;

  try {
    result = await db.query(
      'task',
      where: 'title = ?',
      whereArgs: [titulo],
    );
  } catch (e) {
    print('Erro ao consultar o banco de dados de tarefas: $e');
    result = [];
  }

  return result;
}

/// Função assíncrona que limpa a tabela 'task' no banco de dados de tarefas.
///
/// Exclui todos os registros da tabela 'task' e a recria.
///
/// ### Exemplo de uso:
/// ```dart
/// await limparBancoDeDadosTask();
/// ```
Future<void> limparBancoDeDadosTask() async {
  final Database db = await abrirBancoDeDadosTask();

  await db.execute('DROP TABLE IF EXISTS task');

  await db.execute('''
    CREATE TABLE task (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      board_id INTEGER NOT NULL,
      title VARCHAR NOT NULL,
      note TEXT NOT NULL,
      date VARCHAR NOT NULL,
      startTime VARCHAR NOT NULL,
      endTime VARCHAR NOT NULL,
      isCompleted INTEGER,
      FOREIGN KEY(user_id) REFERENCES user(id),
      FOREIGN KEY(board_id) REFERENCES task_board(id)
    )
  ''');
}
