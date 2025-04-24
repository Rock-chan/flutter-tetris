import 'package:tetris_tesouro/http/env_enum.dart';

class Config {
  static const Map<Env, String> envMap = {
    Env.dev: "http://192.168.151.64:8083/api",
    Env.test: "http://test:8083/api",
    Env.prod: "http://1.12.62.189:8083/api",
  };
}
