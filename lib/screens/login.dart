import 'package:flutter/material.dart';

import '../databases/userDatabase.dart' as user_db;
import 'cadastro.dart';
import 'taskBoards.dart';

class Login extends StatefulWidget {

  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  static const Color roxo = Color(0xFF6354B2);
  static const Color amarelo = Color(0xFFFCB917);
  final TextEditingController _emailController = TextEditingController();
  
  final TextEditingController _passwordController = TextEditingController();

  String userName = "";
  
  late TextStyle textStyleCadastrar;
  late TextStyle textStyleButtonText;
  late ButtonStyle buttonStyle;

  @override
  void initState() {
    super.initState();

    textStyleCadastrar = const TextStyle(
      color: Colors.white,
      decoration: TextDecoration.underline,
    );

    textStyleButtonText = const TextStyle(color: roxo);

    buttonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Colors.white), 
      textStyle: MaterialStateProperty.all<TextStyle>(
        const TextStyle(
          fontSize: 18, 
          fontWeight: FontWeight.bold, 
        ),
      ),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
        const EdgeInsets.symmetric(vertical: 24, horizontal: 60), 
      ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0), 
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color.fromARGB(255, 236, 234, 248),
      body: SingleChildScrollView( 
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              
              children: [
                Image.asset(
                  "assets/logo.png", 
                  height: MediaQuery.of(context).size.height * 0.2, 
                  
                  fit: BoxFit.contain, 
                ),

                const SizedBox(height: 10),

                const Text(
                  "PLANNER",
                  style: TextStyle(
                    color: roxo,  
                    fontWeight: FontWeight.bold,  
                    fontSize: 35,  
                    fontFamily: "CupertinoIcons",  
                  ),
                ),

                const SizedBox(height: 10),

                Container (
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.height * 0.4,

                  decoration: BoxDecoration(
                    color: roxo, 
                    border: Border.all(
                      color: Colors.black,
                      width: 2.0, 
                    ),
                    borderRadius: BorderRadius.circular(10.0), 

                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.blue, Colors.purple], 
                    
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextField(
                        style: const TextStyle(
                          color: amarelo,
                          fontSize: 14,
                        ),
                        cursorColor: amarelo,
                        controller: _emailController,

                        decoration: const InputDecoration(
                          labelText: 'E-mail',
                          labelStyle: TextStyle(color: Colors.white),
                          
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),

                          ),

                        ),

                        onChanged: (value) {
                          setState(() {
                            //playerName = value;
                          });
                        },
                      ),

                      const SizedBox(height: 10),
                      
                      TextField(
                        style: const TextStyle(
                          color: amarelo,
                          fontSize: 14,
                        ),
                        cursorColor: amarelo,
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Senha',
                          labelStyle: TextStyle(color: Colors.white),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            //password = value;
                          });
                        },
                      ),
                      const SizedBox(height: 10),

                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onEnter: (event) {
                          setState(() {
                            // Atualizar o estilo do texto para ficar em negrito
                            textStyleCadastrar = const TextStyle(
                              color: amarelo,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                            );
                          });
                        },
                        onExit: (event) {
                          setState(() {
                            // Restaurar o estilo original do texto
                            textStyleCadastrar = const TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.underline,
                            );
                          });
                        },
                        child: GestureDetector(
                          onTap: () {

                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>  Cadastro()),
                              ); 

                          },
                          child: Text(
                            'Novo Usuário? Criar uma Conta',
                            style: textStyleCadastrar,
                          ),
                        ),
                      ),

                      //const SizedBox(height: 50),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.06),

                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onEnter: (event) {
                          setState(() {
                            // Atualizar o estilo do texto para ficar em negrito
                            textStyleButtonText = const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            );

                            buttonStyle = ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFFFCB917)), 
                              textStyle: MaterialStateProperty.all<TextStyle>(
                                const TextStyle(
                                  fontSize: 18, 
                                  fontWeight: FontWeight.bold, 
                                ),
                              ),
                              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                const EdgeInsets.symmetric(vertical: 24, horizontal: 60), 
                              ),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0), 
                                ),
                              ),
                            );
                          });
                        },
                        onExit: (event) {
                          setState(() {
                            textStyleButtonText = const TextStyle(
                                color: roxo,
                                fontWeight: FontWeight.bold,
                              );

                            buttonStyle = ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.white), 
                              textStyle: MaterialStateProperty.all<TextStyle>(
                                const TextStyle(
                                  fontSize: 18, 
                                  fontWeight: FontWeight.bold, 
                                ),
                              ),
                              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                const EdgeInsets.symmetric(vertical: 24, horizontal: 60), 
                              ),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0), 
                                ),
                              ),
                            );
                          });
                        },


                        child: ElevatedButton(
                          onPressed: () {
                          BuildContext currentContext = context; // Salve o contexto antes da operação assíncrona

                          _login().then((validador) {
                            if (validador) {
                              Navigator.push(
                                currentContext, // Use a variável que armazena o contexto
                                MaterialPageRoute(builder: (context) =>  TaskBoards(userName: userName)),
                              );   
                            }  
                          });
                        },

                          style: buttonStyle,
                          child: Text('Login', style: textStyleButtonText)
                        ),
                      ),

                      


                    ],
                  ),
                ),

                ElevatedButton(
                        onPressed: () {
                          user_db.limparBancoDeDados();
                        }, 
                        child: const Text("Limpar BD")
                      )
              ],
            ),
          ),
        ), 
      ),
    );
  }
  
  Future<bool> _login()  async {
    String email = _emailController.text;
    String password = _passwordController.text;

    // Adicione a lógica de verificação de login apropriada aqui
    // Neste exemplo, apenas mostramos uma mensagem no console
    print("Username: $email, Password: $password");
    print("");
    print(user_db.consultarDados());

    List<Map<String, dynamic>> resultados = await user_db.consultarDados();
    for (var resultado in resultados) {
      print('ID: ${resultado['id']}, Nome: ${resultado['name']}, Email: ${resultado['email']}');
    }

    // TODO: Adicione a lógica de autenticação aqui

    List<Map<String, dynamic>> infoUser = await user_db.getInfoUser(email);
    print("infoUser: ${infoUser}");

    if(_autentication(infoUser, password)==true) {
      userName = infoUser[0]["name"];
      print("A");
      return true;
    }
    print("B");
    _showLoginErrorAlertDialog();
    return false;
  }

  bool _autentication( List<Map<String, dynamic>> infoUser, String password) {
    if (infoUser.isNotEmpty) {
      if (infoUser[0]["password"] == password) {
        return true;
      }
    }

    return false;
  }

  void _showLoginErrorAlertDialog() {
  showDialog(
    context: context, // context deve ser fornecido a partir de onde você está chamando esta função
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Erro de Login"),
        content: Text("As credenciais fornecidas são inválidas. Tente novamente."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Feche o AlertDialog
            },
            child: const Text("OK"),
          ),
        ],
      );
    },
  );
}
  
}