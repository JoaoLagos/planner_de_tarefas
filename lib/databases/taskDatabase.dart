/// Arquivo `taskDatabase.dart` - Contém funções para operações no banco de dados relacionadas a Tarefas.
///
/// Este arquivo fornece funcionalidades para operações como abertura/criação do banco de dados de Tarefas,
/// consulta de dados de Tarefas, inserção de novas Tarefas, consulta de informações de Tarefas por título ou data,
/// limpeza da tabela de Tarefas, alteração do estado de conclusão de uma Tarefa, exclusão de uma Tarefa pelo ID
/// e exclusão de todas as Tarefas associadas a um TaskBoard.
///
/// Todas as funções são assíncronas, refletindo a natureza de operações de banco de dados que podem levar algum tempo para serem concluídas.
///
/// O banco de dados de Tarefas possui uma tabela 'task' que armazena informações sobre as Tarefas,
/// incluindo id, user_id, board_id, title, note, date, startTime, endTime e isCompleted.
///
/// O código usa o pacote `sqflite` para interagir com o SQLite, um banco de dados leve embutido em aplicativos Flutter.

import 'package:intl/intl.dart';
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
/// var dadosTarefas = await consultarDadosTask(7);
/// ```
Future<List<Map<String, dynamic>>> consultarDadosTask(int boardId) async {
  final Database db = await abrirBancoDeDadosTask();
  return await db.query('task', where: 'board_id = ?', whereArgs: [boardId]);
}

Future<List<Map<String, dynamic>>> consultarDadosTaskConcluidas(int boardId) async {
  final Database db = await abrirBancoDeDadosTask();
  return await db.query('task', where: 'board_id = ? AND isCompleted = ?', whereArgs: [boardId, 1]);
}

Future<List<Map<String, dynamic>>> consultarDadosTaskRecentes(int user_id) async {
  final Database db = await abrirBancoDeDadosTask();

  // Calculando a data de hoje e a data daqui a 7 dias
  final DateTime hoje = DateTime.now();
  final DateTime dataSeteDiasFrente = hoje.add(Duration(days: 7));

  // Formata as datas para o formato armazenado no banco de dados (YYYY-MM-DD)
  final DateFormat formatadorData = DateFormat('yyyy-MM-dd');
  final String dataFormatadaHoje = formatadorData.format(hoje);
  final String dataFormatadaSeteDiasFrente = formatadorData.format(dataSeteDiasFrente);


  // Consulta usando o intervalo de datas e o user_id
  return await db.query(
    'task',
    where: 'user_id = ? AND date BETWEEN ? AND ?',
    whereArgs: [user_id, dataFormatadaHoje, dataFormatadaSeteDiasFrente],
  );
  
}

/// Função assíncrona que insere uma nova tarefa no banco de dados.
///
/// ### Parâmetros:
///   - `userId`: O ID do usuário associado à tarefa.
///   - `boardId`: O ID do board associado ao quadro.
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
    result = [];
  }

  return result;
}

Future<List<Map<String, dynamic>>> buscarTasksPorData(String date) async {
  final Database db = await abrirBancoDeDadosTask();
  List<Map<String, dynamic>> result;

  try {
    result = await db.rawQuery('''
      SELECT * FROM task
      WHERE date = ?
    ''', [date]);
  } catch (e) {   
    result = [];
    throw e;
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

/// #### Altera o estado de conclusão de uma tarefa no banco de dados.
///
/// Este método atualiza o campo 'isCompleted' de uma tarefa com o ID especificado
/// no banco de dados. O valor booleano `value` determina se a tarefa está concluída (true)
/// ou não concluída (false).
///
/// ### Exemplo de uso:
///
/// ```dart
/// await changeTaskState(true, taskId);
/// ```
Future<void> changeTaskState(bool value, int id) async {
  final Database db = await abrirBancoDeDadosTask();
  try {
    await db.update(
      'task',
      {'isCompleted': value ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id]
    );
  } catch (e) {
  }
}

/// #### Exclui uma tarefa do banco de dados pelo ID.
///
/// Este método exclui uma tarefa do banco de dados com base no ID especificado.
///
/// ### Exemplo de uso:
///
/// ```dart
/// await deleteTask(taskId);
/// ```
Future<void> deleteTask(int id) async {
  final Database db = await abrirBancoDeDadosTask();

  try {
    await db.delete(
      'task',
      where: 'id = ?',
      whereArgs: [id],
    );
  } catch (e) {
    print('Erro ao deletar a tarefa do banco de dados: $e');
  }
}

/// #### Exclui todas as tarefas associadas a um TaskBoard do banco de dados.
///
/// Este método exclui todas as tarefas associadas a um TaskBoard com o ID especificado
/// do banco de dados.
///
/// ### Exemplo de uso:
///
/// ```dart
/// await deleteAllTasksOfBoardId(boardId);
/// ```
Future<void> deleteAllTasksOfBoardId(int board_id) async {
  // Abre o banco de dados
  Database db = await abrirBancoDeDadosTask();

  // Exclui todas as tarefas com o board_id especificado da tabela task
  await db.delete(
    'task',
    where: 'board_id = ?',
    whereArgs: [board_id],
  );
}