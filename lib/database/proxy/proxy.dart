import 'dart:async';

enum ProxyMethods {insert, insertAll, upsert, delete, deleteAll, update, selectAll, existsById}

class ProxyResult<T> {
  final Object? error;
  final ProxyMethods method;
  final T result;

  ProxyResult(this.method, this.result, {this.error});

  bool get hasError => error != null;
  bool get notHasError => error == null;
}

abstract class ProxyPart<T, TID> {
  Future<ProxyResult<bool>> insert(T element, {bool printLog = true});
  Future<ProxyResult<bool>> insertAll(List<T> elements, {bool printLog = true});
  Future<ProxyResult<bool>> upsert(T element, {bool printLog = true});
  Future<ProxyResult<bool>> update(T element, {bool printLog = true});

  Future<ProxyResult<bool>> delete(T element, {bool printLog = true});
  Future<ProxyResult<bool>> deleteAll({bool printLog = true});

  Future<ProxyResult<bool?>> existsById(TID id, {bool printLog = true});

  Future<ProxyResult<List<T>?>> selectAll({bool printLog = true});
}