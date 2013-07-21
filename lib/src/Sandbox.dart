part of dartscale;

class Sandbox {
  
  static Map<Symbol, dynamic> _plugins = new Map<Symbol, dynamic>();
  
  Mediator _mediator;
  
  Sandbox(Mediator this._mediator);
  
  noSuchMethod(Invocation invocation) {
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
  
  static registerPlugin(String name, dynamic plugin) {
    _plugins[new Symbol(name)] = plugin;
  }
  
  MediatorChannel channel (String channelName) {
    return this._mediator.channel(channelName);
  }
}

class NoSuchPluginError implements Exception {
  
  String message;
  
  NoSuchPluginError(String pluginName) {
    this.message = "No plugin named ${pluginName} found!";
  }
}