import 'package:flutter/material.dart';
import 'package:dart_openai/openai.dart';
import 'package:logger/logger.dart';

final log = Logger();

const apiKey =
    String.fromEnvironment('OPENAI_API_KEY', defaultValue: 'api key not found');

void main() async {
  OpenAI.apiKey = apiKey;
  // List<OpenAIModelModel> models = await OpenAI.instance.model.list();

  // text-davinci-003
  // code-davinci-002

  runApp(const AIGuy());
}

class AIGuy extends StatelessWidget {
  const AIGuy({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Guy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> _responses = [];
  String _input = '';

  void _chat() async {
    log.d("Send to openai");
    OpenAIChatCompletionModel chatCompletion =
        await OpenAI.instance.chat.create(
      model: "gpt-3.5-turbo",
      messages: [
        OpenAIChatCompletionChoiceMessageModel(
          content: _input,
          role: OpenAIChatMessageRole.user,
        ),
      ],
    );
    log.d(chatCompletion);
    setState(() {
      _responses.add(chatCompletion.choices.first.message.content);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OutputWidget(_responses),
            TextField(
                onChanged: (text) => _input = text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter a search term',
                )),
            ElevatedButton(onPressed: _chat, child: const Text('go')),
          ],
        ),
      ),
    );
  }
}

class OutputWidget extends StatelessWidget {
  final List<String> responses;
  const OutputWidget(this.responses, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 400,
        child: ListView.builder(
            itemCount: responses.length,
            itemBuilder: (_, index) {
              return Text(responses[index]);
            }));
  }
}
