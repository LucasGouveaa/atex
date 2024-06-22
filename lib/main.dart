import 'package:flutter/material.dart';
import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';

const apiKey = 'AIzaSyCTHhVklSvzfstyJY1o0mzBxYlugOYyu6M';
final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
var response;

void main() async {
  runApp(GerarPromptApp());
}

class GerarPromptApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GerarPromptButton(),
    );
  }
}

class GerarPromptButton extends StatefulWidget {
  @override
  _GerarPromptButtonState createState() => _GerarPromptButtonState();
}

class _GerarPromptButtonState extends State<GerarPromptButton> {
  var txtPergunta = TextEditingController();
  var txtResposta = TextEditingController();

  void exibirPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Prompt Gerado'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  response.text,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Fechar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> gerarPrompt() async {
    String pergunta = txtPergunta.text;
    String resposta = txtResposta.text;

    final content = [
      Content.text('Pergunta: $pergunta'
          'Fundamentada em referências bibliográficas atuais,'
          'verifique o percentual de acerto da resposta com a seguinte rubrica para critério de'
          'avaliação, com 0% (resposta totalmente errada) 25% (o aluno apresentou uma resposta'
          'onde se encontra pequena semelhança) 50% (resposta parcialmente correta) 75% (essa'
          'resposta faltou algum detalhe, porém, está bem próxima a resposta correta) 100% ('
          'resposta correta, tendo uma pequena margem caso o aluno esqueça de trazer um detalhe'
          'não tão importante).'
          'a resposta do aluno foi : $resposta'
          'Forneça um feedback, e referências bibliográficas quanto a assertiva dessa resposta.')
    ];

    response = await model.generateContent(content);

    exibirPrompt(context);
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(
        title: const Text('Gerar Prompt'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: txtPergunta,
                decoration: const InputDecoration(
                  labelText: 'Pergunta:',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: txtResposta,
                decoration: const InputDecoration(
                  labelText: 'Resposta aluno:',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => gerarPrompt(),
              child: const Text('Gerar Prompt'),
            )
          ],
        ),
      ),
    ));
  }
}
