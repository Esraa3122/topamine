import 'package:flutter_dotenv/flutter_dotenv.dart';

enum EnvTypeEnum { dev, proud }

class EnvVariables {
  EnvVariables._();
  static final EnvVariables instance = EnvVariables._();

  String _envType = '';

  Future<void> init({required EnvTypeEnum envType}) async {
    switch (envType) {
      case EnvTypeEnum.dev:
        await dotenv.load(fileName: '.env.dev');

      case EnvTypeEnum.proud:
        await dotenv.load(fileName: '.env.prod');
    }

    _envType = dotenv.get('ENV_TYPE');
  }

  String get envType => _envType;
}
