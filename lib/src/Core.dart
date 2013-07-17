part of dartscale;

class Core {
  
  final Map<String, ClassMirror> _registeredModules = new Map<String, ClassMirror>();
  final Map<String, dynamic> _runningModules = new Map<String, dynamic>();
  
  final Mediator mediator = new Mediator();
  
  void register(dynamic module, [String moduleName = null]) {
    if (_registeredModules.containsKey(moduleName)) {
      throw new StateError("Module ${moduleName} already registered!");
    }
    
    final ClassMirror mirror = reflect(module).type;
    
    _registeredModules[moduleName != null ? moduleName : module.runtimeType.toString()] = mirror;
  }
  
  void unregister(String moduleName) {
    if (!_registeredModules.containsKey(moduleName)) {
      throw new StateError("Module ${moduleName} not registered!");
    }
    
    _registeredModules.remove(moduleName);
  }
  
  void start(String moduleName, [String id = null, dynamic options = null]) {
    if (!_registeredModules.containsKey(moduleName)) {
      throw new StateError("Module ${moduleName} not registered!");
    }
    
    final ClassMirror mirror = _registeredModules[moduleName];
    final String moduleId = id != null ? id : mirror.simpleName.toString();
    final Sandbox sandbox = new Sandbox(this.mediator);
    
    if (_runningModules.containsKey(moduleId)) {
      throw new StateError("Module with id #${moduleId} already running!");
    }
    
    final InstanceMirror moduleInstance = mirror.newInstance(new Symbol(''), [sandbox], null);
    moduleInstance.invoke(new Symbol("start"), [options]);
    
    _runningModules[moduleId] = moduleInstance;
  }
  
  void stop(String moduleId) {
    if (!_runningModules.containsKey(moduleId)) {
      throw new StateError("Module with id #${moduleId} not running!");
    }
    
    _runningModules.remove(moduleId).stop();
  }
  
  dynamic registered([String moduleName = null]) {
    if (moduleName != null) {
      return _registeredModules.containsKey(moduleName);
    }
    else {
      return _registeredModules.keys;
    }
  }
  
  dynamic running([String moduleId = null]) {
    if (moduleId != null) {
      return _runningModules.containsKey(moduleId);
    }
    else {
      return _runningModules.keys;
    }
  }
}