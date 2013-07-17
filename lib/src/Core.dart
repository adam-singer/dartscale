part of dartscale;

class Core {
  
  final Map<Symbol, ClassMirror> _registeredModules = new Map<Symbol, ClassMirror>();
  final Map<Symbol, dynamic> _runningModules = new Map<Symbol, dynamic>();
  
  final Mediator mediator = new Mediator();
  
  void register(dynamic module, [String moduleName = null]) {
    final uniqueModuleName = moduleName != null ? moduleName : module.runtimeType.toString();
    final Symbol uniqueModuleIdentifier = new Symbol(uniqueModuleName);
    
    if (_registeredModules.containsKey(uniqueModuleName)) {
      throw new StateError("Module ${moduleName} already registered!");
    }
    
    final ClassMirror mirror = reflect(module).type;
    _registeredModules[uniqueModuleIdentifier] = mirror;
  }
  
  void unregister(String moduleName) {
    final Symbol uniqueModuleIdentifier = new Symbol(moduleName);
    
    if (!_registeredModules.containsKey(uniqueModuleIdentifier)) {
      throw new StateError("Module ${moduleName} not registered!");
    }
    
    _registeredModules.remove(uniqueModuleIdentifier);
  }
  
  void start(String moduleName, [String id = null, dynamic options = null]) {
    if (!_registeredModules.containsKey(new Symbol(moduleName))) {
      throw new StateError("Module ${moduleName} not registered!");
    }
    
    final ClassMirror mirror = _registeredModules[new Symbol(moduleName)];
    final Symbol moduleId = id != null ? new Symbol(id) : mirror.simpleName;
    final Sandbox sandbox = new Sandbox(this.mediator);
    
    if (_runningModules.containsKey(moduleId)) {
      throw new StateError("Module with id #${moduleId} already running!");
    }
    
    final InstanceMirror moduleInstance = mirror.newInstance(new Symbol(''), [sandbox], null);
    moduleInstance.invoke(new Symbol("start"), [options]);
    
    _runningModules[moduleId] = moduleInstance;
  }
  
  void stop(String moduleId) {
    final Symbol uniqueModuleIdentifier = new Symbol(moduleId);
    
    if (!_runningModules.containsKey(uniqueModuleIdentifier)) {
      throw new StateError("Module with id #${moduleId} not running!");
    }
    
    _runningModules.remove(uniqueModuleIdentifier).stop();
  }
  
  dynamic registered([String moduleName = null]) {
    if (moduleName != null) {
      return _registeredModules.containsKey(new Symbol(moduleName));
    }
    else {
      return _registeredModules.keys;
    }
  }
  
  dynamic running([String moduleId = null]) {
    if (moduleId != null) {
      return _runningModules.containsKey(new Symbol(moduleId));
    }
    else {
      return _runningModules.keys;
    }
  }
}