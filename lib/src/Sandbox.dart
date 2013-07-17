part of dartscale;

class Sandbox {
  
  static Map<Symbol, dynamic> _plugins = new Map<Symbol, dynamic>();
  
  Mediator mediator;
  
  Sandbox(Mediator this.mediator);
  
  dynamic noSuchMethod(Invocation invocation) {
      var plugin = _plugins[invocation.memberName];
      
      if (invocation.isSetter) {
        throw new UnsupportedError("Setting Plugins is not allowed!");
      }
      
      if (plugin == null) {
        throw new NoSuchPluginError(invocation.memberName.toString());
      }
      
      if (invocation.isGetter || invocation.isAccessor) {
        return plugin;
      }
      else if (invocation.isMethod) {
        return Function.apply(plugin, invocation.positionalArguments, invocation.namedArguments);
      }
      
      
  }
  
  static void registerPlugin(String name, dynamic plugin) {
    _plugins[new Symbol(name)] = plugin;
  }
}

class NoSuchPluginError implements Exception {
  
  String message;
  
  NoSuchPluginError(String pluginName) {
    this.message = "No plugin named ${pluginName} found!";
  }
}