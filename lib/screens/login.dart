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

  Map<String, dynamic> user = {};
  
  late TextStyle textStyleCadastrar;
  late TextStyle textStyleButtonText;
  late ButtonStyle buttonStyle;

  // Como textStyleCadastrar, textStyleButtonText e buttonStyle precisam ser primeiramente inicializados, colocamos dentro do initState.
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(80.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                            
                          });
                        },
                      ),
                      const SizedBox(height: 10),

                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onEnter: (event) { // Se em versão Web, configurações para caso o mouse esteja em cima desse Widget
                          setState(() {
                            
                            textStyleCadastrar = const TextStyle(
                              color: amarelo,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                            );
                          });
                        },
                        onExit: (event) { // Se em versão Web, configurações para caso o mouse saia de cima desse Widget
                          setState(() {
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

                      SizedBox(height: MediaQuery.of(context).size.height * 0.06),

                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onEnter: (event) { // Se em versão Web, configurações para caso o mouse esteja em cima desse Widget
                          setState(() {
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
                        onExit: (event) { // Se em versão Web, configurações para caso o mouse saia de cima desse Widget
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
                          BuildContext currentContext = context; // Salva o contexto antes da operação assíncrona

                          _login(_emailController, _passwordController).then((validador) {
                            if (validador) {
                              Navigator.push(
                                currentContext, // Usa a variável que armazena o contexto
                                MaterialPageRoute(builder: (context) =>  TaskBoards(user: user)),
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

                ElevatedButton( // Colocado somente para limpar o banco de dados, pois ao fechar a aplicação os dados continuam lá, não resetam
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
  

  /// ### Função assíncrona responsável por realizar o processo de autenticação do usuário.
  /// 
  /// Esta função obtém o e-mail e a senha inseridos nos campos de entrada de texto,
  /// verifica as credenciais no banco de dados e, se as credenciais forem válidas,
  /// armazena o nome do usuário e retorna `true`. Caso contrário, exibe um alerta de erro
  /// e retorna `false`.
  /// 
  /// ### Parâmetros:
  ///   - `_emailController`: Controlador do campo de entrada de e-mail.
  ///   - `_passwordController`: Controlador do campo de entrada de senha.
  /// 
  /// ### Retorna:
  ///   - `true` se a autenticação for bem-sucedida, `false` caso contrário.
  Future<bool> _login(TextEditingController emailController, TextEditingController passwordController)  async {
    String email = emailController.text;
    String password = passwordController.text;

    // Obtém informações do usuário do banco de dados
    List<Map<String, dynamic>> infoUser = await user_db.getInfoUser(email);

    // Verifica se as credenciais são válidas. Sendo válida, variável user recebe o nome do usuário  e a função retorna true
    if(_autentication(infoUser, password)==true) {
      user = infoUser[0];
      return true;
    }

    // Exibe um alerta de erro em caso de credenciais inválidas e retorna false
    _showLoginErrorAlertDialog();
    return false;
  }

  /// ### Função responsável por autenticar as credenciais do usuário.
  /// 
  /// Esta função recebe uma lista de informações do usuário e uma senha como parâmetros.
  /// Ela verifica se a lista de informações do usuário não está vazia e se a senha
  /// fornecida corresponde à senha armazenada no banco de dados. Se as condições
  /// forem atendidas, a função retorna `true`, indicando autenticação bem-sucedida;
  /// caso contrário, retorna `false`.
  /// 
  /// ### Exemplo:
  /// ```dart
  /// String emailDigitado = "usuario@email.com"
  /// List<Map<String, dynamic>> infoUsuario = await user_db.getInfoUser(emailDigitado);
  /// String senhaDigitada = 'senha123';
  /// bool autenticado = _autentication(infoUsuario, senhaDigitada);
  /// print(autenticado); // Saída esperada: true se as credenciais forem autenticadas, false caso contrário.
  /// ```
  /// 
  /// ### Parâmetros:
  ///   - `infoUser`: Lista de informações do usuário, geralmente obtida do banco de dados.
  ///   - `password`: Senha fornecida para autenticação.
  /// 
  /// ### Retorna:
  ///   - `true` se as credenciais forem autenticadas com sucesso, `false` caso contrário.
  bool _autentication( List<Map<String, dynamic>> infoUser, String password) {
    if (infoUser.isNotEmpty) {
      if (infoUser[0]["password"] == password) {
        return true;
      }
    }

    return false;
  }

  /// Exibe um diálogo de alerta para erros de login.
  ///
  /// Este método cria e exibe um [AlertDialog] informando ao usuário que houve
  /// um erro nas credenciais fornecidas durante o processo de login.
  ///
  /// Para utilizar este método, forneça o contexto (`context`) de onde você
  /// está chamando esta função.
  ///
  /// ### Parâmetros:
  ///   - `context`: O contexto onde o diálogo será exibido. Geralmente obtido
  ///     de `BuildContext` no local de chamada.
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