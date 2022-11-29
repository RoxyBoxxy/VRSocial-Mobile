import 'dart:collection';

import 'package:colibri/core/common/api/api_constants.dart';
import 'package:colibri/core/common/failure.dart';
import 'package:colibri/core/datasource/local_data_source.dart';
import 'package:colibri/core/di/injection.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@injectable
class ApiHelper {
  final Dio? dio = getIt<Dio>();
  final LocalDataSource? localDataSource;
  ApiHelper(this.localDataSource) {
    dio!.options.baseUrl = ApiConstants.baseUrl;
    final interceptor = InterceptorsWrapper(
      onError: (e) {
        if (e.response?.data != null)
          print("error in response ${e.response?.data["message"]}");
      },
      onResponse: (res) async {
        // if(res.data["code"]==401){
        //   dio.interceptors.requestLock.lock();
        //   dio.interceptors.responseLock.lock();
        //   dio.interceptors.errorLock.lock();
        //   var loginResponse = await localDataSource.getUserAuth();
        //   final Dio tokenDio = new Dio();
        //   tokenDio.options=dio.options;
        //   Response response = await tokenDio.post("refresh_access_token",data: FormData.fromMap(HashMap.from({"refresh_token":loginResponse.refreshToken})));
        //    await localDataSource.saveUserAuthentication(UserAuth.fromJson(response.data["data"]));
        //    final request = res.request;
        //
        //   print("refresh:${response.data}");
        //   return  dio.request(request.path,options: request);

        // }
        // print("success response ${res.data.toString()}");
      },
      onRequest: (req) async {
        // adding auth token
        var loginResponse = await localDataSource!.getUserAuth();
        if (loginResponse != null) {
          req.headers.addAll({"session_id": loginResponse.authToken});
          if (req.method == "GET") {
            req.queryParameters.addAll({"session_id": loginResponse.authToken});
          } else {
            var updatedReq = (req.data as FormData)
              ..fields.add(MapEntry("session_id", loginResponse.authToken!));
            req.data = updatedReq;
          }
        }
        (req.data as FormData?)?.fields?.forEach((element) {
          print(element);
        });
      },
    );
    dio!.interceptors
      ..add(interceptor)
      ..add(
          LogInterceptor(request: true, responseBody: true, requestBody: true));
    // ..add(PrettyDioLogger(requestBody: true,requestHeader: true,request: true))
  }

  Future<Either<Failure, Response>> post(
          String path, HashMap<String, dynamic> body,
          {dynamic headers}) async =>
      safeApiHelperRequest(() => dio!.post(path,
          data: FormData.fromMap(body), options: Options(headers: headers)));

  Future<Either<Failure, Response>> get<T>(String path,
          {Map<String, dynamic>? headers,
          Map<String, dynamic>? queryParameters}) async =>
      safeApiHelperRequest(() => dio!.get(path,
          options: Options(headers: headers!),
          queryParameters: queryParameters!));

  Future<Either<Failure, Response>> put<T>(String path,
          {Map<String, dynamic>? headers, dynamic body}) async =>
      safeApiHelperRequest(() =>
          dio!.put(path, options: Options(headers: headers!), data: body));

  Future<Either<Failure, Response>> safeApiHelperRequest(
      Future<dynamic> Function() function) async {
    try {
      var response = await function.call();
      if (response.data["code"] == 200 || response.data["status"] == 200)
        return Right(response);
      else if (response.data["code"] == 204)
        return left(NoDataFoundFailure(
            response.data["message"] ?? "Something went wrong"));
      return Left(
          ServerFailure(response.data["message"] ?? "Something went wrong"));
    } on DioError catch (e) {
      return Left(ServerFailure(_handleError(e)));
    }
  }

  String _handleError(DioError error) {
    String errorDescription = "";
    if (error is DioError) {
      DioError dioError = error;
      switch (dioError.type) {
        case DioErrorType.CANCEL:
          errorDescription = "Request to API server was cancelled";
          break;
        case DioErrorType.CONNECT_TIMEOUT:
          errorDescription = "Connection timeout with API server";
          break;
        case DioErrorType.DEFAULT:
          errorDescription =
              "Connection to API server failed due to internet connection";
          break;
        case DioErrorType.RECEIVE_TIMEOUT:
          errorDescription = "Receive timeout in connection with API server";
          break;
        case DioErrorType.RESPONSE:
          errorDescription =
              "Received invalid status code: ${dioError.response.statusCode}";
          break;
        case DioErrorType.SEND_TIMEOUT:
          errorDescription = "Send timeout in connection with API server";
          break;
      }
    } else {
      errorDescription = "Unexpected error occured";
    }
    return errorDescription;
  }
}
