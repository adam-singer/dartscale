import 'package:unittest/unittest.dart';
import '../lib/dartscale.dart';

class TestModule {
  
  Sandbox sandbox;
  bool isRunning;
  
  TestModule(Sandbox this.sandbox);
  
  void start(Sandbox sandbox) {
    this.sandbox;
    this.isRunning = true;
  }
  
}

void main () {
  test("Can register Module", () {
    Core core = new Core();
    
    core.register(new TestModule(null));
    
    expect(core.registered("TestModule"), equals(true));
  });
  
  test("Can register multiple Modules", () {
    Core core = new Core();
    
    core.register(new TestModule(null), "ModuleNameOne");
    core.register(new TestModule(null), "ModuleNameTwo");
    
    Iterable registeredModules = core.registered();
    
    expect(registeredModules.contains("ModuleNameOne"), equals(true));
    expect(registeredModules.contains("ModuleNameTwo"), equals(true));
  });
  
  test("Can register Module with custom Name", () {
    Core core = new Core();
    
    core.register(new TestModule(null), "NewName");
    
    expect(core.registered("NewName"), equals(true));
  });
  
  test("Can unregister Module", () {
    Core core = new Core();
    
    core.register(new TestModule(null));
    core.unregister("TestModule");
    
    expect(core.registered("TestModule"), equals(false));
  });
  
  test("Can unregister Module with custom Name", () {
    Core core = new Core();
    
    core.register(new TestModule(null), "NewName");
    core.unregister("NewName");
    
    expect(core.registered("NewName"), equals(false));
  });
  
  test("Can start Module", () {
    Core core = new Core();
    TestModule testModule = new TestModule(null);
    
    core.register(testModule);
    core.start("TestModule");
    
    ///lots of work needs to be done
    ///expect(core.running("TestModule"), equals(true));
  });
}

