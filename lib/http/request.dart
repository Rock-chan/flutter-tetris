import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:tetris_tesouro/http/env_enum.dart';
import 'package:tetris_tesouro/http/http_log.dart';
import 'package:tetris_tesouro/http/options/req_options.dart';
import 'package:tetris_tesouro/http/options/res_options.dart';
import 'package:tetris_tesouro/http/response_entity.dart';
import 'package:tetris_tesouro/utils/time_utils.dart';

class TreasureRequest {
  static Map<Env, String>? _baseUrlMap;

  static Env? _env;

  String? _baseUrl;

  static init(Map<Env, String> map, Env env) {
    _baseUrlMap = map;
    _env = env;
  }

  /// 单例模式
  static TreasureRequest? _instance;

  /// 工厂函数：执行初始化
  factory TreasureRequest() => _instance ?? TreasureRequest._internal();

  /// 获取实例对象时，如果有则返回，没有则初始化
  static TreasureRequest? get instance =>
      _instance ?? TreasureRequest._internal();

  /// dio实例
  static Dio? _dio;

  ///是否打印日志到控制台
  static bool enablePrintLog = true;

  ReqOptions? _options;

  ResOptions? _resOptions;

  /// 初始化
  TreasureRequest._internal() {
    assert(_baseUrlMap != null);
    switch (_env!) {
      case Env.dev:
        enablePrintLog = true;
        break;
      case Env.test:
        enablePrintLog = false;
        break;
      case Env.prod:
        enablePrintLog = true;
        break;
    }
    _baseUrl = _baseUrlMap![_env];

    /// 初始化基本选项
    BaseOptions options = BaseOptions(
      baseUrl: _baseUrl!,
      connectTimeout: const Duration(milliseconds: 10000),
      receiveTimeout: const Duration(milliseconds: 10000),
    );
    _instance = this;
    _dio = Dio(options);
    // _dio!.interceptors.add(InterceptorsWrapper(onRequest: _onRequest, onResponse: _onResponse, onError: _onError));
    _dio!.interceptors
      ..add(CustomLogInterceptor())
      ..add(InterceptorsWrapper(onRequest: (options, handler) {
        return handler.next(options);
      }));
  }

  void saveResponse(Response response) {
    var resOpt = ResOptions();
    resOpt.id = response.requestOptions.hashCode;
    resOpt.responseTime = DateTime.now();
    resOpt.statusCode = response.statusCode ?? 0;
    resOpt.data = response.data;
    resOpt.headers = response.headers.map;
    if (enablePrintLog) {
      log('request: url: ${_options?.url}');
      log('request: method: ${_options?.method}');
      log('request: params: ${_options?.params}');
      log('request: data: ${_options?.data}');
      log('request: duration: ${getTimeStr1(_options!.requestTime!)}');
      log('response: ${toJson(_resOptions?.data)}');
    }
  }

  ///返回json格式的String
  toJson(dynamic data) {
    var je = const JsonEncoder.withIndent('  ');
    var json = je.convert(data);
    return json;
  }

  Future<dynamic> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    var response = await _dio?.get(path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress);
    ResponseEntity entity =
        ResponseEntity.fromJson(jsonDecode(response.toString()));
    return entity.data;
  }

  Future<dynamic> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    var response = await _dio?.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
    ResponseEntity entity =
        ResponseEntity.fromJson(jsonDecode(response.toString()));
    return entity.data;
  }

  Future<dynamic> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    var response = await _dio?.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
    ResponseEntity entity =
        ResponseEntity.fromJson(jsonDecode(response.toString()));
    return entity.data;
  }

  Future<dynamic> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    var response = await _dio?.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
    ResponseEntity entity =
        ResponseEntity.fromJson(jsonDecode(response.toString()));
    return entity.data;
  }

  Future<dynamic> thirdPartyRequest(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    var response = await _dio?.get(path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress);
    if (response?.data['status'] != null) {
      if (response?.data['status'] == '0') {
        "${response?.data['info']}";
      }
    }
    return response;
  }
}
