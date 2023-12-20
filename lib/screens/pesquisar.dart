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
            const SizedBox(height: 16), // Espaçamento entre os botões e o texto
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
                    backgroundColor: roxo, // Altere para a cor desejada
                  ),
                  child: Text(
                    '${selectedDay ?? 'DD'}/${selectedMonth ?? 'MM'}/${selectedYear ?? 'AAAA'}',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ]
            ),
            const SizedBox(height: 16), // Espaçamento entre os botões e o texto
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
                backgroundColor: Colors.green,  // Altere para a cor desejada
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

    // Faz a consulta
    List<Map<String, dynamic>> resultados = await task_db.buscarTasksPorData(date);

    setState(() {
      // Atualiza o widget do resultado com o novo FutureBuilder
      _resultadoWidget = widgetResultadoPesquisa(resultados);
    });
  }

  Widget widgetResultadoPesquisa(List<Map<String, dynamic>> resultados) {
    
    //String date = [ano, mes, dia].join('-');
    
    

    //TODO:
    return FutureBuilder<List<Map<String, dynamic>>>(
    future: Future.value(resultados), // Usa Future.value para um futuro já resolvido
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator(); // Exibe um indicador de carregamento enquanto aguarda a conclusão da consulta
      } else if (snapshot.hasError) {
        return Text('Erro ao carregar os dados'); // Exibe uma mensagem de erro, caso ocorra algum problema
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Text('Nenhum resultado encontrado'); // Se não houver dados ou a lista estiver vazia
      } else {
        List<Map<String, dynamic>> resultados = snapshot.data!;

        

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20), // Espaçamento entre o botão e a lista de resultados
            const Text(
              'Resultados:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10), // Espaçamento entre o texto "Resultados" e a lista

            // Lista de resultados exibida após a pesquisa
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: resultados.length,
                itemBuilder: (BuildContext context, int index) {
                  Map<String, dynamic> item = resultados[index];
                  String title = item['title'] ?? ''; // Obtendo o título da tarefa
                  String note = item['note'] ?? ''; // Obtendo a nota da tarefa
                  String date = item['date'] ?? ''; // Obtendo a data da tarefa
                  String startTime = item['startTime'] ?? ''; // Obtendo o horário de início da tarefa
                  String endTime = item['endTime'] ?? ''; // Obtendo o horário de término da tarefa


                  return Card(
                    elevation: 3, // Adiciona sombra ao card
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4), // Espaçamento entre os cards
                    child: ListTile(
                          title: Text(
                            title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Padding(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(note),
                                SizedBox(height: 4),
                                Text('Data: $date'),
                                SizedBox(height: 4),
                                Text('Inicio: $startTime'),
                                SizedBox(height: 4),
                                Text('Término: $endTime'),
                              ],
                            ),
                          ),
                          onTap: () {
                            // Ação ao clicar no item
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
