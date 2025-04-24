import 'package:dio/dio.dart';
import 'package:tetris_tesouro/http/response_entity.dart';

/// [CustomLogInterceptor] is used to print logs during network requests.
/// It's better to add [CustomLogInterceptor] to the tail of the interceptor queue,
/// otherwise the changes made in the interceptor behind A will not be printed out.
/// This is because the execution of interceptors is in the order of addition.
class CustomLogInterceptor extends Interceptor {
  CustomLogInterceptor({
    this.request = true,
    this.requestHeader = true,
    this.requestBody = false,
    this.responseHeader = true,
    this.responseBody = false,
    this.error = true,
    this.logPrint = print,
  });

  /// Print request [Options]
  bool request;

  /// Print request header [Options.headers]
  bool requestHeader;

  /// Print request data [Options.data]
  bool requestBody;

  /// Print [Response.data]
  bool responseBody;

  /// Print [Response.headers]
  bool responseHeader;

  /// Print error message
  bool error;

  /// Log printer; defaults print log to console.
  /// In flutter, you'd better use debugPrint.
  /// you can also write log in a file, for example:
  ///```dart
  ///  var file=File("./log.txt");
  ///  var sink=file.openWrite();
  ///  dio.interceptors.add(LogInterceptor(logPrint: sink.writeln));
  ///  ...
  ///  await sink.close();
  ///```
  void Function(Object object) logPrint;

  @override
  void onRequest(RequestOptions options,
      RequestInterceptorHandler handler) async {
    logPrint('*** Request ***');
    _printKV('uri', options.uri);
    //options.headers;

    if (request) {
      _printKV('method', options.method);
      // _printKV('responseType', options.responseType.toString());
      // _printKV('followRedirects', options.followRedirects);
      // _printKV('connectTimeout', options.connectTimeout);
      // _printKV('sendTimeout', options.sendTimeout);
      // _printKV('receiveTimeout', options.receiveTimeout);
      // _printKV(
      //     'receiveDataWhenStatusError', options.receiveDataWhenStatusError);
      // _printKV('extra', options.extra);
    }
    if (requestHeader) {
      logPrint('headers:');
      options.headers.forEach((key, v) => _printKV(' $key', v));
    }
    if (requestBody) {
      logPrint('data:');
      _printAll(options.data);
    }
    logPrint('');

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    logPrint('*** Response ***');
    _printResponse(response);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (error) {
      logPrint('*** DioError ***:');
      logPrint('uri: ${err.requestOptions.uri}');
      logPrint('$err');
      if (err.response != null) {
        _printResponse(err.response!);
      }
      if (err.response?.statusCode == 500) {
        "系统错误, 请稍后再试";
      } else {
        // if (ObjectUtil.isEmpty(err.response)) {
        //   "Por favor, aceite a rede e tente novamente".toast();
        // } else {
        //   err.response?.data['message'].toString().toast();
        // }
        "Por favor, aceite a rede e tente novamente";
      }
      logPrint('this is error ${err.response}');
    }

    handler.next(err);
  }

  void _printResponse(Response response) {
    _printKV('uri', response.requestOptions.uri);
    if (responseHeader) {
      _printKV('statusCode', response.statusCode);
      if (response.isRedirect == true) {
        _printKV('redirect', response.realUri);
      }

      logPrint('headers:');
      response.headers.forEach((key, v) => _printKV(' $key', v.join('\r\n\t')));
    }
    logPrint('Response Text:');
    ResponseEntity responseEntity = ResponseEntity.fromJson(response.data);
    logPrint('\tcode: ${responseEntity.code}');
    logPrint('\tmessage: ${responseEntity.message}');
    logPrint('\tdata: ${responseEntity.data}');
    logPrint('response text: ${response.data}');
  }

  void _printKV(String key, Object? v) {
    logPrint('$key: $v');
  }

  void _printAll(msg) {
    msg.toString().split('\n').forEach(logPrint);
  }
}
