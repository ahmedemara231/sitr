import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../config/language/languages.dart' show Languages;
import '../../config/language/locale_keys.g.dart';
import '../../config/res/config_imports.dart';
import '../error/exceptions.dart';
import '../shared/base_model.dart';
import 'configuration_interceptor.dart';
import 'extensions.dart';
import 'log_interceptor.dart';
import 'network_request.dart';
import 'network_service.dart';

class DioService implements NetworkService {
  late final Dio _dio;

  DioService() {
    _initDio();
  }

  void _initDio() {
    _dio = Dio()
      ..options.baseUrl = ConstantManager.baseUrl
      ..options.connectTimeout = const Duration(
        seconds: ConstantManager.connectTimeoutDuration,
      )
      ..options.receiveTimeout = const Duration(
        seconds: ConstantManager.recieveTimeoutDuration,
      )
      ..options.headers.addAll({
        HttpHeaders.acceptHeader: ContentType.json,
        Headers.contentTypeHeader: Headers.jsonContentType,
        HttpHeaders.acceptLanguageHeader:
            Languages.currentLanguage.locale.languageCode
      })
      ..options.responseType = ResponseType.json;

    if (kDebugMode) {
      _dio.interceptors.addAll([
        LoggerInterceptor(),
        ConfigurationInterceptor(),
      ]);
    }
  }

  @override
  void setToken(String token) {
    _dio.options.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
  }

  @override
  void removeToken() {
    _dio.options.headers.remove(HttpHeaders.authorizationHeader);
  }

  @override
  Future<BaseModel<Model>> callApi<Model>(NetworkRequest networkRequest,
      {Model Function(dynamic json)? mapper}) async {
    try {
      await networkRequest.prepareRequestData();
      final response = await _dio.request(networkRequest.path,
          data: networkRequest.hasBodyAndProgress()
              ? networkRequest.isFormData
                  ? FormData.fromMap(networkRequest.body!)
                  : networkRequest.body
              : networkRequest.body,
          queryParameters: networkRequest.queryParameters,
          onSendProgress: networkRequest.hasBodyAndProgress()
              ? networkRequest.onSendProgress
              : null,
          onReceiveProgress: networkRequest.hasBodyAndProgress()
              ? networkRequest.onReceiveProgress
              : null,
          options: Options(
              method: networkRequest.asString(),
              headers: networkRequest.headers
          ));
      if (mapper != null) {
        return BaseModel.fromJson(response.data, jsonToModel: mapper);
      } else {
        return BaseModel.fromJson(response.data);
      }
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  dynamic _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw NoInternetConnectionException(LocaleKeys.checkInternet);
      case DioExceptionType.badResponse:
        switch (error.response!.statusCode) {
          case HttpStatus.badRequest:
            throw BadRequestException(
              error.response?.data['message'] ?? LocaleKeys.badRequest,
            );
          case HttpStatus.unauthorized:
            throw UnauthorizedException(
              error.response?.data['message'] ?? LocaleKeys.unauthorized,
            );
          case HttpStatus.locked:
            throw BlockedException(
              error.response?.data['message'] ?? LocaleKeys.unauthorized,
            );
          case HttpStatus.notFound:
            throw NotFoundException(LocaleKeys.notFound);
          case HttpStatus.conflict:
            throw ConflictException(
              error.response?.data['message'] ?? LocaleKeys.serverError,
            );
          case HttpStatus.internalServerError:
            throw InternalServerErrorException(
              error.response?.data['message'] ?? LocaleKeys.serverError,
            );
          default:
            throw ServerException(LocaleKeys.serverError);
        }
      case DioExceptionType.cancel:
        throw ServerException(LocaleKeys.intenetWeakness);
      case DioExceptionType.unknown:
        throw ServerException(
          error.response?.data['message'] ?? LocaleKeys.exceptionError,
        );
      default:
        throw ServerException(
          error.response?.data['message'] ?? LocaleKeys.exceptionError,
        );
    }
  }
}
