import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

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
                // Adicione a lógica que deve ser executada ao selecionar a opção do menu
                Navigator.pop(context); // Fecha o Drawer
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
              onTap: () {
                Navigator.pop(context); // Fecha o Drawer
                // TODO: query baseada no user taskList = await task_bd.consultarDadosTask(user);
                List<Map<String, dynamic>> taskList =  [];
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  RecentTasksView(taskList: taskList, user: widget.user)));
              },
            ),
            ListTile(
              leading: const Icon(Icons.done),
              title: const Text('Tarefas Concluídas'),
              onTap: () {
                Navigator.pop(context); // Fecha o Drawer
                // TODO: query baseada no user taskList = await task_bd.consultarDadosTask(user);
                List<Map<String, dynamic>> taskList =  [];
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
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            SizedBox(height: MediaQuery.of(context).size.height * 0.01),

            Image.asset(
              "assets/user.png",
              height: 90,
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
                      getIconFromName(icon),
                      size: 45,
                      color: cinza,
                    ),
                  ],
                ),

                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 0.498),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),  // Raio na parte inferior esquerda
                      bottomRight: Radius.circular(20.0), // Raio na parte inferior direita
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

  // Função para exibir o AlertDialog de pesquisa
  Future<void> exibirDialogoPesquisa(BuildContext context) async {
    TextEditingController controller = TextEditingController();
    
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pesquisar Tarefa'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Nome da Tarefa'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // Aqui você pode acessar o nome da tarefa digitado usando controller.text
                
                Navigator.of(context).pop();
              },
              child: const Text('Pesquisar'),
            ),
          ],
        );
      },
    );
  }

  void abrirTelaPesquisa(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Pesquisar(
        onPesquisaConfirmada: (data) {
          // Aqui você pode lidar com os resultados da pesquisa
          
          // Incluir aqui a lógica para exibir as tarefas correspondentes à pesquisa
        },
      ),
    ),
  );
}

Future<void> exibirDialogoInserirTarefa(BuildContext context) async {
  String nomeTarefa = ''; // Variável para armazenar o nome da nova tarefa
  Color corSelecionada = Colors.blue; // Valor padrão, você pode definir a cor padrão desejada

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
              )
            ],
          )
        ),
        actions: [
          TextButton(
            onPressed: () {
              // taskboard_bd.limparBancoDeDadosTaskBoard();
              setState(() {
                
              });
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              taskboard_bd.inserirDadosTaskBoard(nomeTarefa, nomeTarefa, widget.user["id"], corSelecionada.value);
              print('Nome da nova tarefa: $nomeTarefa');

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


IconData getIconFromName(String iconName) {
    // TODO: fazer um iconpicker na hora de criar a terefa
  switch (iconName) {
    case 'Trabalho':
      return Icons.work;
    case 'Saúde':
      return Icons.health_and_safety;
    case 'Academia':
      return Icons.health_and_safety;
    case 'Estudo':
      return Icons.book;
    // Adicione mais casos conforme necessário
    default:
      return Icons.error; // Ou o ícone padrão que você preferir
  }
}


}