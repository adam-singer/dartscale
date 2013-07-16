part of dartscale;

class NoSuchPluginError implements Exception {
  
  String message;
  
  NoSuchPluginError(String pluginName) {
    this.message = "No plugin named ${pluginName} found!";
  }
}