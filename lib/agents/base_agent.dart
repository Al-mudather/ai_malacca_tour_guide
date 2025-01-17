import 'package:langchain_openai/langchain_openai.dart';

abstract class BaseAgent {
  final ChatOpenAI llm;

  BaseAgent(this.llm);

  Future<dynamic> execute();
}
