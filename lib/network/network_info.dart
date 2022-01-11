import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:meta/meta.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl({@required this.connectionChecker})
      : assert(connectionChecker != null);

  final DataConnectionChecker connectionChecker;

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
