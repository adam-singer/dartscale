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
  
  void start([dynamic moduleName, String id, dynamic options]) {
    if (moduleName is String) {
      this._start(new Symbol(moduleName), id, options);
    }
    else if (moduleName is List) {
      for (String name in moduleName) {
        this._start(new Symbol(name), id, options);
      }
    }
    else if (moduleName == null) {
      for (Symbol name in _registeredModules.keys) {
        this._start(name, id, options);
      }
    }
    else {
      throw new ArgumentError("Invalid Type given for argument moduleName");
    }
  }
  
  void _start(Symbol moduleName, [String id, dynamic options]) {
    if (!_registeredModules.containsKey(moduleName)) {
      throw new StateError("Module ${moduleName} not registered!");
    }
    
    final ClassMirror mirror = _registeredModules[moduleName];
    final Symbol moduleId = id != null ? new Symbol(id) : moduleName;
    final Sandbox sandbox = new Sandbox(this.mediator);
    
    if (_runningModules.containsKey(moduleId)) {
      throw new StateError("Module with id #${moduleId} already running!");
    }
    
    final InstanceMirror moduleInstance = mirror.newInstance(new Symbol(''), [sandbox], null);
    moduleInstance.invoke(new Symbol("start"), [options]);
    
    _runningModules[moduleId] = moduleInstance;
  }
  
  void stop([dynamic moduleId]) {
    if (moduleId is String) {
      this._stop(new Symbol(moduleId));
    }
    else if (moduleId is List) {
      for (String id in moduleId) {
        this._stop(new Symbol(id));
      }
    }
    else if (moduleId == null) {
      List<Symbol> ids = [];
      
      ///_stop manipulates HasMap, thus it'd result in an error
      ///calling _stop in the key iteration
      for (Symbol id in _runningModules.keys) {
        ids.add(id);
      }
      
      ids.forEach((Symbol id) => this._stop(id));
      
    }
    else {
      throw new ArgumentError("Invalid Type given for argument moduleId");
    }
  }
  
  void _stop(Symbol moduleId) {
    if (!_runningModules.containsKey(moduleId)) {
      throw new StateError("Module with id #${moduleId} not running!");
    }
    
    _runningModules.remove(moduleId).invoke(new Symbol("stop"), []);
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