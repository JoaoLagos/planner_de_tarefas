/// `taskBoards.dart` - Tela principal que exibe os quadros de tarefas.
///
/// Este arquivo contém a implementação da tela principal (`TaskBoards`), que exibe
/// os quadros de tarefas do usuário. Os quadros incluem informações sobre a categoria
/// de tarefas, como nome, ícone, cor e a quantidade de tarefas associadas. A tela também
/// fornece um menu de navegação lateral (drawer) para acessar outras seções do aplicativo.
///
/// O widget é parte integrante do aplicativo Planner, que oferece recursos de gerenciamento
/// de tarefas e organização. A tela principal fornece uma visão geral dos quadros de tarefas
/// e permite a navegação para outras áreas, como pesquisar tarefas, visualizar tarefas recentes,
/// visualizar tarefas concluídas e sair do aplicativo.
///
/// O arquivo contém a classe `TaskBoards` (um StatefulWidget) e sua respectiva implementação
/// de estado `_TaskBoardsState`. A classe inclui métodos para construir a interface do usuário,
/// abrir a tela de pesquisa, exibir o diálogo para inserir uma nova tarefa e criar widgets de
/// cartão para exibir informações sobre os quadros de tarefas.

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:table_calendar/table_calendar.dart';

import 'pesquisar.dart';
import 'login.dart';
import 'tasksView.dart';
import 'recentTasks.dart';
import 'completedTasks.dart';
import '../databases/taskboardDatabase.dart'as taskboard_bd;
import '../databases/taskDatabase.dart'as task_bd;

class TaskBoards extends StatefulWidget {
  final Map<String, dynamic> user;

  const TaskBoards({Key? key, required this.user}) : super(key: key);

  @override
  State<TaskBoards> createState() => _TaskBoardsState();
}

class _TaskBoardsState extends State<TaskBoards> {
  static const Color roxo = Color(0xFF6354B2);
  static const Color cinza = Color(0xFF403C44);

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Boards"),
        centerTitle: true,
        backgroundColor: roxo,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO:
              exibirDialogoInserirTarefa(context);
            },
          ),
        ],
      ),

      // Menu Sanduíche
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: roxo,
              ),
              child: Text(
                'MENU',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Página Inicial'),
              onTap: () {
                
                Navigator.pop(context); 
              },
            ),
            
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Pesquisar'),
              onTap: () {
                // ABRIR O PESQUISA AQUI!
                Navigator.pop(context); // Fecha o Drawer
                abrirTelaPesquisa(context);


              },
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Tarefas Recentes'),
              onTap: () async {
                Navigator.pop(context); // Fecha o Drawer
                // TODO: query baseada no user taskList = await task_bd.consultarDadosTask(user);
                List<Map<String, dynamic>> taskList =  await task_bd.consultarDadosTaskRecentes(widget.user["id"]);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  RecentTasksView(taskList: taskList, user: widget.user)));
              },
            ),
            ListTile(
              leading: const Icon(Icons.done),
              title: const Text('Tarefas Concluídas'),
              onTap: () async {
                Navigator.pop(context); // Fecha o Drawer
                // TODO: query baseada no user taskList = await task_bd.consultarDadosTask(user);
                List<Map<String, dynamic>> taskList =  await task_bd.consultarDadosTaskConcluidas(widget.user["id"]);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  CompletedTasksView(taskList: taskList, user: widget.user)));
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Sair'),
              onTap: () {
                // ABRIR O PESQUISA AQUI!
                Navigator.pop(context); // Fecha o Drawer
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));


              },
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child:Center(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(height: MediaQuery.of(context).size.height * 0.01),

              Image.asset(
                "assets/user.png",
                height: 60,
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.01),

              Text(
                "Bem-vindo, ${widget.user["name"]}",
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.01),

              TableCalendar(firstDay: DateTime.utc(1970, 1, 1), focusedDay: DateTime.now() , lastDay: DateTime.utc(2038, 12, 31),),

              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              
              FutureBuilder<int>(
                future: taskboard_bd.tamanhoByUser(widget.user["id"]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Erro ao carregar dados do banco de dados');
                  } else {
                    int tamanho = snapshot.data ?? 0;

                    return Column(
                      children: [
                        for (int i = 0; i < tamanho; i += 2)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FutureBuilder<List<Map<String, dynamic>>>(
                                future: taskboard_bd.getInfoTaskBoardByUser(widget.user["id"]),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return const Text('Erro ao carregar dados do board');
                                  } else {
                                    // Verifique se a lista tem algum item antes de acessar o primeiro elemento
                                    if (snapshot.data!.isNotEmpty && widget.user["id"] == snapshot.data![i]["user_id"]) {
                                      Map<String, dynamic> boardData = snapshot.data![i];

                                      return FutureBuilder<List<Map<String, dynamic>>>(future: task_bd.consultarDadosTask(boardData["id"]), builder:
                                      (context, taskListSnapshot) {
                                        if (taskListSnapshot.connectionState == ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else if (taskListSnapshot.hasError) {
                                          return Text('Erro ao buscar tarefas: ${taskListSnapshot.error}');
                                        } else {
                                          List<Map<String, dynamic>> taskList = taskListSnapshot.data ?? [];
                                          return cardWidget(
                                            boardData["name"] ?? "",
                                            boardData["icon"] ?? "error",
                                            boardData["color"] ?? 0,
                                            taskList,
                                            boardData["id"],
                                          );
                                        }
                                      });
                                    } else {
                                      return const Text('Nenhum dado encontrado');
                                    }
                                  }
                                },
                              ),
                              if (i + 1 < tamanho)
                                FutureBuilder<List<Map<String, dynamic>>>(
                                  future: taskboard_bd.getInfoTaskBoardByUser(widget.user["id"]),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return const Text('Erro ao carregar dados do board');
                                    } else {
                                      // Verifique se a lista tem algum item antes de acessar o primeiro elemento
                                      if (snapshot.data!.isNotEmpty && widget.user["id"] == snapshot.data![i+1]["user_id"]) {
                                        Map<String, dynamic> boardData = snapshot.data![i+1];

                                        return FutureBuilder<List<Map<String, dynamic>>>(future: task_bd.consultarDadosTask(boardData["id"]), builder:
                                            (context, taskListSnapshot) {
                                          if (taskListSnapshot.connectionState == ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          } else if (taskListSnapshot.hasError) {
                                            return Text('Erro ao buscar tarefas: ${taskListSnapshot.error}');
                                          } else {
                                            List<Map<String, dynamic>> taskList = taskListSnapshot.data ?? [];
                                            return cardWidget(
                                              boardData["name"] ?? "",
                                              boardData["icon"] ?? "error",
                                              boardData["color"] ?? 0,
                                              taskList,
                                              boardData["id"]
                                            );
                                          }
                                        });
                                      } else {
                                        return const Text('Nenhum dado encontrado');
                                      }
                                    }
                                  },
                                ),
                            ],
                          ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        )
      )
    );
  }

  /// Retorna um widget de cartão personalizado para exibir informações sobre uma categoria de tarefas.
  ///
  /// Este método cria e retorna um widget de cartão que exibe o título da categoria,
  /// um ícone representativo e informações adicionais, como a quantidade de tarefas.
  ///
  /// ### Parâmetros:
  ///   - `titulo`: O título da categoria a ser exibido no cartão.
  ///   - `icon`: O ícone representativo da categoria.
  ///   - `cor`: A cor de fundo do cartão.
  ///   - `id`: id do board na db.
  ///
  /// ### Exemplo de uso:
  /// ```dart
  /// cardWidget("Trabalho", Icons.work, const Color(0xFF7EB0D5)),
  /// ```
  ///
  /// ### Retorna:
  /// Um widget de cartão personalizado.
  Widget cardWidget(String titulo, String icon, int cor, List<Map<String, dynamic>>? taskList, int boardId) {

    return InkWell(onTap: () async {
      await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TasksView(taskList: taskList, boardName: titulo, user: widget.user, boardId: boardId, cor: cor)));
    },
        child: Padding(
        padding: const EdgeInsets.all(8.0),
        child:Container(
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.height * 0.20,

          decoration: BoxDecoration(
            color: Color(cor),
            borderRadius: BorderRadius.circular(20.0),
          ),

          child: Padding(

            padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 0),
                  child: Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: cinza,
                    ),
                  ),
                ),

                //SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      IconData(
                        icon.codeUnitAt(0), // Pega o icone(String) e transforma em icone(int)
                        fontFamily: 'MaterialIcons', // Substitua pela família de fontes apropriada
                      ),
                      size: 45,
                      color: cinza,
                    ),
                  ],
                ),

                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 0.498),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),  
                      bottomRight: Radius.circular(20.0), 
                    ),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "${taskList!.isEmpty ? 'sem' : taskList.length } ${taskList.length == 1 ? 'tarefa' : 'tarefas'}",
                          style: const TextStyle(
                              color: cinza,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        )
    ));
  }


  void abrirTelaPesquisa(BuildContext context) {
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Pesquisar(
          onPesquisaConfirmada: (data) {
            
          },          
        ),
      ),
    );
  }

Future<void> exibirDialogoInserirTarefa(BuildContext context) async {
  String nomeTarefa = ''; 
  Color corSelecionada = Colors.blue; // Valor padrão
  IconData? iconeSelecionado = Icons.error; // Valor padrão
  String stringIconeSelecionado = String.fromCharCode(iconeSelecionado.codePoint);



  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Novo Quadro'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (valor) {
                  nomeTarefa = valor;
                },
                decoration: const InputDecoration(
                  hintText: 'Insira o nome do novo quadro',
                ),
              ),
              const SizedBox(height: 20),
              const Text('Escolha a cor:'),
              const SizedBox(height: 8),
              ColorPicker(
                pickerColor: corSelecionada,
                onColorChanged: (color) {
                  corSelecionada = color;
                },
                colorPickerWidth: 300.0,
                pickerAreaHeightPercent: 0.7,
                enableAlpha: false,
                displayThumbColor: true,
                showLabel: true,
                paletteType: PaletteType.hsv,
                pickerAreaBorderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(2.0),
                  topRight: Radius.circular(2.0),
                ),
              ),

              TextButton(
                onPressed: () async {
                  iconeSelecionado = await FlutterIconPicker.showIconPicker(context);
                  if (iconeSelecionado != null) {
                    stringIconeSelecionado = String.fromCharCode(iconeSelecionado!.codePoint);

                  }
                },
                child: const Text('Selecionar ícone'),
              ),
            ],
          )
        ),
        actions: [
          TextButton(
            onPressed: () {
              // taskboard_bd.limparBancoDeDadosTaskBoard();
              // taskboard_bd.deleteAllTaskBoardsOfUser(widget.user["id"]);
              setState(() {
                
              });
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              taskboard_bd.inserirDadosTaskBoard(nomeTarefa, stringIconeSelecionado, widget.user["id"], corSelecionada.value);

              setState(() {
              });
              Navigator.pop(context);
            },
            child: const Text('Inserir'),
          ),
        ],
      );
    },
  );
}


}