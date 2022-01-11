abstract class Failure {
  String failureMessage;

  Failure(this.failureMessage);
}

class AuthorizationFailure extends Failure {
  AuthorizationFailure({String failureMessage: "Authorization Failure"})
      : super(failureMessage);
}

class LocationFailure extends Failure {
  LocationFailure({String failureMessage: "Failed to retrieve Location"})
      : super(failureMessage);
}

//server responds but not expected
class ServerFailure extends Failure {
  ServerFailure({String message: "Server Failure"}) : super(message);
}

//Cache responds but not expected
class CacheFailure extends Failure {
  CacheFailure({String failureMessage: "Cache Failure"})
      : super(failureMessage);
}

//NetworkFailure
class NetworkFailure extends Failure {
  NetworkFailure(
      {String failureMessage: "Please check your network connection"})
      : super(failureMessage);
}

//anything else
class UnknownFailure extends Failure {
  UnknownFailure({String failureMessage: "Unknown Failure"})
      : super(failureMessage);
}

// class SocialFailure extends Failure {
//   SocialFailure({String failureMessage: "Unable to login with social site"})
//       : super(failureMessage);
// }
