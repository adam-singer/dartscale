part of dartscale;

/**
 * Context in which [Module]s live.
 * 
 * An application can consist of multiple contexts.
 */
class Context {
  Map<String, Module>   _modules = new Map<String, Module>();
  Map<String, Module>   get modules => this._modules;
  
  Map<String, Map<String, StreamController>> _streams = new Map<String, Map<String, StreamController>>();
  
  void register(String moduleId, Module module) {
    if (this._modules.containsKey(moduleId)) {
      throw new Exception("module with id ${moduleId} already registered");
    }
    else {
      this._modules[moduleId] = module;
      module.onRegister();
    }
  }
  
  void unregister(String moduleId) {
    if (!this._modules.containsKey(moduleId)) {
      throw new Exception("no module with id ${moduleId} registered");
    }
    else {
      this._modules[moduleId].onUnregister();
      this._modules.remove(moduleId);
    }
  }
  
  void start([modules]) {
    var ids = new List<String>();
    
    if (modules != null) {
      if (modules is String) {
        ids.add(modules);
      }
      else if (modules is List) {
        ids = modules;
      }
      else {
        throw new TypeError("only List<String> and String arguments are allowed");
      }
    }
    else {
      ids = this._modules.keys;
    }
    
    
    for (String moduleId in ids) {
      if (this._modules.containsKey(moduleId)) {
        this._modules[moduleId].onStart();
      }
    }
  }
  
  void stop([modules]) {
    var ids = new List<String>();
    
    if (modules != null) {
      if (modules is String) {
        ids.add(modules);
      }
      else if (modules is List) {
        ids = modules;
      }
      else {
        throw new TypeError("only List<String> and String arguments are allowed");
      }
    }
    else {
      ids = this._modules.keys;
    }
    
    
    for (String moduleId in ids) {
      if (this._modules.containsKey(moduleId)) {
        this._modules[moduleId].onStop();
      }
    }
  }
  
  
 
  void emit(String channel, String topic, dynamic data) {
    final StreamController controller = getStreamController(channel, topic);
    controller.add(data);    
  }
  
  StreamController getStreamController(String channel, String topic) {
    Map<String, StreamController> topicMap;
    if (_streams.containsKey(channel)) {
      topicMap = _streams[channel];
    }
    else {
      topicMap = new Map<String, StreamController>();
      _streams[channel] = topicMap;
    }
    
    StreamController stream;
    if (topicMap.containsKey(topic)) {
      stream = topicMap[topic];
    }
    else {
      stream = new StreamController();
      topicMap[topic] = stream;
    }
    
    return stream;
  }
  
  Stream getStream(String channel, String topic) {
    
    return this.getStreamController(channel, topic).stream;
  }
}