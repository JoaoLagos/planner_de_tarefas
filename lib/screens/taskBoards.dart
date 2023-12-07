import 'package:flutter/material.dart';

class TaskBoards extends StatefulWidget {
  const TaskBoards({super.key});

  @override
  State<TaskBoards> createState() => _TaskBoardsState();
}

class _TaskBoardsState extends State<TaskBoards> {
  static const Color roxo = Color(0xFF6354B2);
  static const Color cinza = Color(0xFF403C44);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Boards"),
        centerTitle: true,
        backgroundColor: roxo,
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Image.asset(
            "../../assets/user.png",
            height: 90,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),

          const Text(
            "Bem-vindo, Usuário 1",
            style: TextStyle(
              fontSize: 20.0, // Defina o tamanho da fonte desejado
              fontWeight: FontWeight.bold, // Pode ser alterado para FontWeight.normal, FontWeight.w500, etc.
              color: Colors.black, // Defina a cor do texto conforme necessário
              // Adicione outras propriedades de estilo conforme necessário
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              cardWidget("Trabalho", Icons.work, const Color(0xFF7EB0D5)),
              cardWidget("Saúde", Icons.health_and_safety, const Color(0xFFB2E061)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              cardWidget("Academia", Icons.self_improvement, const Color(0xFFBD7EBE)),
              cardWidget("Estudo", Icons.book, const Color(0xFFFFB55A))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              cardWidget("Errand", Icons.flutter_dash, const Color(0xFFFFEE65)),
              cardWidget("Outros", Icons.menu, roxo)
            ],
          )
        ],
      ),
    );
  }


  Widget cardWidget(String titulo, IconData icon, Color cor) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child:Container(
        width: MediaQuery.of(context).size.width * 0.4, 
        height: MediaQuery.of(context).size.height * 0.20, 
        
        decoration: BoxDecoration(
          color: cor,
          borderRadius: BorderRadius.circular(20.0), 
        ), 
        
        child: Padding(
          //padding: const EdgeInsets.all(16.0),
          padding: EdgeInsets.fromLTRB(0, 16.0, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16.0, 0, 0, 0),
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
                    icon,
                    size: 45,
                    color: cinza,
                  ),
                ],
              ),

              Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 0.498), // Defina a cor de fundo desejada aqui
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),  // Raio na parte inferior esquerda
                    bottomRight: Radius.circular(20.0), // Raio na parte inferior direita
                  ),
                ),
                child: const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "1 task",
                        style: TextStyle(
                          color: cinza,
                          fontWeight: FontWeight.bold // Defina a cor do texto
                          // Outras propriedades de estilo podem ser adicionadas conforme necessário
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
    );
  }
}