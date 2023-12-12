import 'package:flutter/material.dart';

class Pesquisar extends StatefulWidget {
  final Function(DateTime) onPesquisaConfirmada;

  const Pesquisar({Key? key, required this.onPesquisaConfirmada}) : super(key: key);

  @override
  State<Pesquisar> createState() => _PesquisarState();
}

class _PesquisarState extends State<Pesquisar> {
  int? selectedDay;
  int? selectedMonth;
  int? selectedYear;

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
                  // Chame a função de pesquisa confirmada com a data selecionada
                  widget.onPesquisaConfirmada(DateTime(selectedYear!, selectedMonth!, selectedDay!));
                  Navigator.pop(context);
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
            ///////////////////////////////////////
            //widgetResultadoPesquisa(context),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
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

/*
  Widget widgetResultadoPesquisa(BuildContext context) {
    // TODO:
    return // AQUI!;
  }
*/
}
