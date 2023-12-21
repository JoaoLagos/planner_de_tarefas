/// `pesquisar.dart` - Tela de Pesquisa de Tarefas por Data.
///
/// Este arquivo contém a implementação da tela de pesquisa de tarefas por data, onde os usuários podem
/// selecionar uma data específica e visualizar as tarefas associadas a essa data. A tela inclui a seleção
/// de data, um botão de pesquisa e exibe os resultados da pesquisa em uma lista de cartões.
///
/// O widget é parte integrante do aplicativo Planner, que oferece recursos de gerenciamento de tarefas e
/// organização. A pesquisa por data é uma funcionalidade útil para os usuários acompanharem suas tarefas
/// em datas específicas.
///
/// A classe `Pesquisar` (um StatefulWidget) inclui métodos como `_selectDate` para escolher uma data,
/// `_buscarEAtualizarResultado` para realizar a pesquisa no banco de dados e atualizar os resultados,
/// e `widgetResultadoPesquisa` para construir o widget de resultados usando um FutureBuilder.
///
/// A tela utiliza o pacote `taskDatabase.dart` para interagir com o banco de dados de tarefas e exibir
/// os resultados da pesquisa em uma lista de cartões.

import 'package:flutter/material.dart';
import '../databases/taskDatabase.dart' as task_db;


class Pesquisar extends StatefulWidget {
  final Function(DateTime) onPesquisaConfirmada;
  //List<Map<String, dynamic>> taskDataList;

  const Pesquisar({Key? key, required this.onPesquisaConfirmada}) : super(key: key);

  @override
  State<Pesquisar> createState() => _PesquisarState();
}

class _PesquisarState extends State<Pesquisar> {


  int? selectedDay;
  int? selectedMonth;
  int? selectedYear;
  late Widget _resultadoWidget; // Variável para armazenar o widget de resultado

  @override
  void initState() {
    super.initState();
    _resultadoWidget = Container(); // Inicializa o _resultadoWidget com um Container vazio
  }

  static const Color roxo = Color(0xFF6354B2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesquisar Tarefa'),
        backgroundColor: roxo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [
                const Text(
                  'Data Selecionada: ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: roxo, 
                  ),
                  child: Text(
                    '${selectedDay ?? 'DD'}/${selectedMonth ?? 'MM'}/${selectedYear ?? 'AAAA'}',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ]
            ),
            const SizedBox(height: 16), 
            ElevatedButton(
              onPressed: () {
                if (selectedYear != null && selectedMonth != null && selectedDay != null) {
                  _buscarEAtualizarResultado(context, selectedYear, selectedMonth, selectedDay);
                 
                } else {
                  // TODO: Fazer
                  print('Por favor, selecione uma data completa.');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,  
              ),
              
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                child: Text(
                  'Pesquisar',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            Expanded(
              child: _resultadoWidget,
            ),
          ],
        ),
      ),
      
    );
  }

  Future<void> _selectDate(BuildContext context, ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        selectedDay = picked.day;
        selectedMonth = picked.month;
        selectedYear = picked.year;
      });
    }
  }

   Future<void> _buscarEAtualizarResultado(BuildContext context, int? ano, int? mes, int? dia) async {
    String date = [ano, mes, dia].join('-');

    List<Map<String, dynamic>> resultados = await task_db.buscarTasksPorData(date);

    setState(() {
      _resultadoWidget = widgetResultadoPesquisa(resultados);
    });
  }

  Widget widgetResultadoPesquisa(List<Map<String, dynamic>> resultados) {
    //String date = [ano, mes, dia].join('-');
    
    //TODO:
    return FutureBuilder<List<Map<String, dynamic>>>(
    future: Future.value(resultados), 
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator(); 
      } else if (snapshot.hasError) {
        return const Text('Erro ao carregar os dados'); 
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Text('Nenhum resultado encontrado'); 
      } else {
        List<Map<String, dynamic>> resultados = snapshot.data!;

        

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20), 
            const Text(
              'Resultados:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10), 

            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: resultados.length,
                itemBuilder: (BuildContext context, int index) {
                  Map<String, dynamic> item = resultados[index];
                  String title = item['title'] ?? ''; 
                  String note = item['note'] ?? ''; 
                  String date = item['date'] ?? ''; 
                  String startTime = item['startTime'] ?? ''; 
                  String endTime = item['endTime'] ?? ''; 


                  return Card(
                    elevation: 3, 
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4), 
                    child: ListTile(
                          title: Text(
                            title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(note),
                                const SizedBox(height: 4),
                                Text('Data: $date'),
                                const SizedBox(height: 4),
                                Text('Inicio: $startTime'),
                                const SizedBox(height: 4),
                                Text('Término: $endTime'),
                              ],
                            ),
                          ),
                          onTap: () {
                            
                          },
                        ),

                  );
                },
              ),
            ),
          ],
        );
      }
    },
  );
  }

}
