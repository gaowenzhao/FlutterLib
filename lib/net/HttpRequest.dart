import 'dart:io';
import 'package:dio/dio.dart';
import 'package:connectivity/connectivity.dart';
import 'Code.dart';
import 'Config.dart';
import 'package:flutterlib/net/HttpResult.dart';
import '../PackInfoUtils.dart';
///http请求管理类，可单独抽取出来
class HttpRequest {
//  static String _baseUrl = "https://m.hzed.com";
//  static String _baseUrl = "http://10.10.30.137";
  static String _baseUrl = "https://timeline-merger-ms.juejin.im";
  static const CONTENT_TYPE_JSON = "application/json";
  static const CONTENT_TYPE_FORM = "application/x-www-form-urlencoded";

  static get(url,{param}) async{
    return await request(url, param,  new Options(method:"GET"));
  }

  static post(url,{param}) async{
    return await request(url, param, Options(method: 'POST'));
  }

  ///发起网络请求
  ///[ url] 请求url
  ///[ params] 请求参数
  ///[ header] 外加头
  ///[ option] 配置
  static request(url, params,  Options option, {noTip = false}) async {
    //没有网络
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return new HttpResult(Code.errorHandleFunction(Code.NETWORK_ERROR, "", noTip), false, Code.NETWORK_ERROR);
    }
    BaseOptions options = BaseOptions();
    options.baseUrl = _baseUrl;
    options.contentType = ContentType.parse(CONTENT_TYPE_JSON);
    String version = await PackInfoUtils.geVersionName();
    options.headers = {"version":version,"client":"2"};
    Dio dio = new Dio(options);
//    _initOption(option,header);
    // 添加拦截器
    if (Config.DEBUG) {
/*      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        // config the http client
        client.findProxy = (uri) {
          return "PROXY 192.168.0.8:8888";//如果设置代理（localhost,127.0.0.1这样的是不行的。必须是电脑的ip）
//        return 'DIRECT';// 如果不设置代理
        };
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;//忽略证书
      };*/
      dio.interceptors.add(InterceptorsWrapper(
          onRequest: (RequestOptions options){
            print("\n================== 请求数据 ==========================");
            print("url = ${options.uri.toString()}");
            print("headers = ${options.headers}");
            print("params = ${options.data}");
          },
          onResponse: (Response response){
            print("\n================== 响应数据 ==========================");
            print("code = ${response.statusCode}");
            print("data = ${response.data}");
            print("\n");
          },
          onError: (DioError e){
            print("\n================== 错误响应数据 ======================");
            print("type = ${e.type}");
            print("message = ${e.message}");
            print("stackTrace = ${e.stackTrace}");
            print("\n");
          }
      ));
    }

    Response response;
    try {
      if(option.method == "POST"){
        response = await dio.post(url, data: params, options: option);
      }else{
          response = await dio.get(url, queryParameters:params, options: option);
      }
    } on DioError catch (e) {
      // 请求错误处理
      Response errorResponse;
      if (e.response != null) {
        errorResponse = e.response;
      } else {
        errorResponse = new Response(statusCode: 666);
      }
      if (e.type == DioErrorType.CONNECT_TIMEOUT) {
        errorResponse.statusCode = Code.NETWORK_TIMEOUT;
      }
      if (Config.DEBUG) {
        print('请求异常: ' + e.toString());
        print('请求异常 url: ' + url);
      }
      var result = HttpResult(Code.errorHandleFunction(errorResponse.statusCode, e.message, noTip), false, errorResponse.statusCode);
      return result;
    }
    try {
      if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
        return HttpResult(response.data, true, Code.SUCCESS, headers: response.headers);
      }
    } catch (e) {
      print(e.toString() + url);
      return HttpResult(response.data, false, response.statusCode, headers: response.headers);
    }
    return new HttpResult(Code.errorHandleFunction(response.statusCode, "", noTip), false, response.statusCode);
  }
}
