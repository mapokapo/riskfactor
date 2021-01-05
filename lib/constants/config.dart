import 'package:riskfactor/constants/routes.dart';

/// Config object for the app.
///
/// Instantiate a new instance of this class at the start of your app.
class Config {
  /// Adds the debug banner and disables all http requests.
  bool devMode;

  /// The initial route of the app.
  ///
  /// Use the `Routes` class to avoid typos in the route paths.
  String initialRoute;

  Config({this.devMode = false, this.initialRoute = Routes.landing});
}
