import 'package:unittest/unittest.dart';
import '../lib/dartscale.dart';

class TestModule {
  
  Sandbox sandbox;
  
  TestModule([Sandbox this.sandbox]);
  
  void start(Sandbox sandbox) {}
  
  void stop() {}
  
}

void main () {
  test("Can register Module", () {
    Core core = new Core();
    
    core.register(new TestModule());
    
    expect(core.registered("TestModule"), equals(true));
  });
  
  test("Can register multiple Modules", () {
    Core core = new Core();
    
    core.register(new TestModule(), "ModuleNameOne");
    core.register(new TestModule(), "ModuleNameTwo");
    
    Iterable registeredModules = core.registered();
    
    expect(registeredModules.contains(new Symbol("ModuleNameOne")), equals(true));
    expect(registeredModules.contains(new Symbol("ModuleNameTwo")), equals(true));
  });
  
  test("Can register Module with custom Name", () {
    Core core = new Core();
    
    core.register(new TestModule(), "NewName");
    
    expect(core.registered("NewName"), equals(true));
  });
  
  test("Can unregister Module", () {
    Core core = new Core();
    
    core.register(new TestModule());
    core.unregister("TestModule");
    
    expect(core.registered("TestModule"), equals(false));
  });
  
  test("Can unregister Module with custom Name", () {
    Core core = new Core();
    
    core.register(new TestModule(), "NewName");
    core.unregister("NewName");
    
    expect(core.registered("NewName"), equals(false));
  });
  
  test("Can start Module", () {
    Core core = new Core();
    TestModule testModule = new TestModule();
    
    core.register(testModule);
    core.start("TestModule");
    
    expect(core.running("TestModule"), equals(true));
  });
  
  test("Can start multiple Modules", () {
    Core core = new Core();
    
    core.register(new TestModule(), "ModuleNameOne");
    core.register(new TestModule(), "ModuleNameTwo");
    
    core.start(["ModuleNameOne", "ModuleNameTwo"]);
    
    expect(core.running("ModuleNameOne"), equals(true));
    expect(core.running("ModuleNameTwo"), equals(true));
  });
  
  test("Can start all Modules", () {
    Core core = new Core();
    
    core.register(new TestModule(), "ModuleNameOne");
    core.register(new TestModule(), "ModuleNameTwo");
    core.register(new TestModule(), "ModuleNameThree");
    
    core.start();
    
    expect(core.running().length, equals(3));
    expect(core.running("ModuleNameOne"), equals(true));
    expect(core.running("ModuleNameTwo"), equals(true));
    expect(core.running("ModuleNameThree"), equals(true));
  });
  
  test("Can stop Module", () {
    Core core = new Core();
    TestModule testModule = new TestModule();
    
    core.register(testModule);
    core.start("TestModule");
    core.stop("TestModule");
    
    expect(core.running("TestModule"), equals(false));
  });
  
  test("Can stop multiple Modules", () {
    Core core = new Core();
    
    core.register(new TestModule(), "ModuleNameOne");
    core.register(new TestModule(), "ModuleNameTwo");
    
    core.start(["ModuleNameOne", "ModuleNameTwo"]);
    core.stop(["ModuleNameOne", "ModuleNameTwo"]);
    
    expect(core.running("ModuleNameOne"), equals(false));
    expect(core.running("ModuleNameTwo"), equals(false));
  });
  
  test("Can stop all Modules", () {
    Core core = new Core();
    
    core.register(new TestModule(), "ModuleNameOne");
    core.register(new TestModule(), "ModuleNameTwo");
    core.register(new TestModule(), "ModuleNameThree");
    
    core.start();
    core.stop();
    
    expect(core.running().length, equals(0));
    expect(core.running("ModuleNameOne"), equals(false));
    expect(core.running("ModuleNameTwo"), equals(false));
    expect(core.running("ModuleNameThree"), equals(false));
  });
}

