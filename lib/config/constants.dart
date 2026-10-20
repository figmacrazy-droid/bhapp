import 'package:flutter_dotenv/flutter_dotenv.dart';

String get GROQ_API_KEY => dotenv.env['GROQ_API_KEY'] ?? '';

String get GROQ_MODEL => dotenv.env['GROQ_MODEL'] ?? 'qwen/qwen3.8-27b';

const String GROQ_API_URL = 'https://api.groq.com/openai/v1/chat/completions';

const Duration API_TIMEOUT = Duration(seconds: 45);