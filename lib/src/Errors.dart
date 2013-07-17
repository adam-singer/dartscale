part of dartscale;

class NoSuchPluginError implements Exception {
  
  String message;
  
  NoSuchPluginError(String pluginName) {
    this.message = "No plugin named ${pluginName} found!";
  }
}

class ModuleAlreadyRegisteredError implements Exception {
  String message;
  
  ModuleAlreadyRegisteredError(String moduleName) {
    this.message = "Module ${moduleName} already registered!";
  }
}