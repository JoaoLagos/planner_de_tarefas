/// `recentTasksView.dart` - Visualização de Tarefas Recentes.
///
/// Este arquivo contém a implementação da tela de visualização de tarefas recentes, onde os usuários podem
/// ver suas tarefas dos últimos 7 dias. A tela inclui uma tabela de expansão que exibe informações detalhadas
/// sobre cada tarefa, como título, data, início, fim, notas e estado de conclusão.
///
/// O widget é parte integrante do aplicativo Planner, que oferece recursos de gerenciamento de tarefas e
/// organização. A visualização de tarefas recentes é útil para os usuários acompanharem suas atividades mais
/// recentes.
///
/// A classe `RecentTasksView` (um StatefulWidget) inclui métodos como `updateTaskList` para atualizar a lista
/// de tarefas, e a classe `TaskTable` (um StatefulWidget) é usada para construir a tabela de expansão.
///
/// A tela utiliza o pacote `taskDatabase.dart` para interagir com o banco de dados de tarefas e exibir as
/// informações relevantes.

import 'package:flutter/material.dart';
import '../databases/taskDatabase.dart'as task_bd;
import 'taskBoards.dart';

class RecentTasksView extends StatefulWidget {
  List<Map<String, dynamic>> taskList;
  final Map<String, dynamic> user;

  RecentTasksView({Key? key, required this.taskList, required this.user}) : super(key: key);

  @override
  State<RecentTasksView> createState() => RecentTasksViewState();
}

class RecentTasksViewState extends State<RecentTasksView> {

  static const Color roxo = Color(0xFF6354B2);
  final GlobalKey<TaskTableState> _taskTableKey = GlobalKey<TaskTableState>();


  Future<void> updateTaskList() async{
    // TODO: query baseada no user taskList = await task_bd.consultarDadosTask(user);
    List<Map<String, dynamic>> taskList =  [];
    setState(() {
      widget.taskList = taskList;
      _taskTableKey.currentState?.updateTaskList(List.generate(taskList.length, (index) => false), taskList.map((task) => task["isCompleted"] == 1).toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Tarefas recentes"),
          backgroundColor: roxo,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white), //arrow color based on the board color
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  TaskBoards(user: widget.user))),
          ),),
        body: SingleChildScrollView(child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                "Veja suas tarefas dos útimos 7 dias",
                style: TextStyle(color: roxo, fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              if (widget.taskList.isEmpty)
                const Text("Sem tarefas")
              else
                TaskTable(key: _taskTableKey,taskDataList: widget.taskList, onUpdate: updateTaskList)
            ],
          ),
        ),)
    );
  }
}

class TaskTable extends StatefulWidget {
  List<Map<String, dynamic>> taskDataList;
  final void Function() onUpdate;

  TaskTable({super.key, required this.taskDataList, required this.onUpdate});

  @override
  TaskTableState createState() => TaskTableState();
}

class TaskTableState extends State<TaskTable> {
  List<bool> _isOpen = [];
  List<bool> isCheckedList = [];

  @override
  void initState() {
    super.initState();
    _isOpen = List.generate(widget.taskDataList.length, (index) => false);
    for(var task in widget.taskDataList){
      isCheckedList.add(task["isCompleted"] == 1);
    }
  }

  void updateTaskList(List<bool> newList, List<bool> newCompletedList){
    setState(() {
      _isOpen = newList;
      isCheckedList = newCompletedList;
    });
  }


  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      elevation: 1,
      expandedHeaderPadding: const EdgeInsets.all(0),
      children: [
        for (var index = 0; index < widget.taskDataList.length; index++)
          ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              var taskData = widget.taskDataList[index];
              return Row(
                children: [
                  Checkbox(
                    value: isCheckedList[index],
                    activeColor: Colors.green,
                    onChanged: (value) async {
                      await task_bd.changeTaskState(value!, taskData["id"]);
                      setState(() {
                        isCheckedList[index] = value;
                      });
                    },
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(taskData['title'] ?? ''),
                        Text(taskData['date'] ?? ''),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() async {
                        await task_bd.deleteTask(taskData["id"]);
                        widget.onUpdate();
                      });
                    },
                    child: const Icon(Icons.delete, color: Colors.red,),
                  )
                ],
              );
            },
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Início:  ${widget.taskDataList[index]['startTime'] ?? ''}'),
                      Text('Fim:     ${widget.taskDataList[index]['endTime'] ?? ''}'),
                    ],
                  ),
                  const SizedBox(width: 16,),
                  Flexible(child: Text('Notas: ${widget.taskDataList[index]['note'] ?? ''}')),
                ],
              ),
            ),
            isExpanded: _isOpen[index],
            canTapOnHeader: true,
          ),
      ],
      expansionCallback: (index, isOpen) =>
          setState(() {
            _isOpen[index] = isOpen;
          }),
    );

  }
}




