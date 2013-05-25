import 'package:unittest/unittest.dart';
import '../lib/dartscale.dart';

class TestModule extends Module {
  
  var lastReceivedMessage;
  var registered;
  var unregistered;
  var started;
  var stopped;
  
  TestModule(Context context):super(context);
  
  void onRegister() {
    this.registered = true;
    this.unregistered = false;
  }
  
  void onUnregister() {
    this.registered = false;
    this.unregistered = true;
  }
  
  void onStart() {
    this.started = true;
    this.stopped = false;
  }
  
  void onStop() {
    this.stopped = true;
    this.started = false;
  }
}

void main () {
  test("Module created", () {
    var context = new Context();
    var testModule = new TestModule(context);
    
    expect(testModule.context, equals(context));
  });
  
  test("Module registered", () {
    var context = new Context();
    var testModule = new TestModule(context);
    context.register("TestModule", testModule);
    
    expect(context.modules.containsKey("TestModule"), equals(true));
    expect(testModule.registered, equals(true));
  });
  
  test("Module unregistered", () {
    var context = new Context();
    var testModule = new TestModule(context);
    context.register("TestModule", testModule);
    context.unregister("TestModule");
    
    expect(context.modules.containsKey("TestModule"), equals(false));
    expect(testModule.unregistered, equals(true));
  });
  
  test("single Module started", () {
    var context = new Context();
    var testModule = new TestModule(context);
    context.register("TestModule", testModule);
    context.start("TestModule");
    
    expect(testModule.started, equals(true));
  });
  
  test("single Module stoped", () {
    var context = new Context();
    var testModule = new TestModule(context);
    context.register("TestModule", testModule);
    context.stop("TestModule");
    
    expect(testModule.stopped, equals(true));
  });
  
  test("multiple Modules started", () {
    var context = new Context();
    var testModule1 = new TestModule(context);
    var testModule2 = new TestModule(context);
    var testModule3 = new TestModule(context);
    context.register("TestModule1", testModule1);
    context.register("TestModule2", testModule2);
    context.register("TestModule3", testModule3);
    context.start(["TestModule1", "TestModule2", "TestModule3"]);
    
    expect(testModule1.started, equals(true));
    expect(testModule2.started, equals(true));
    expect(testModule3.started, equals(true));
  });
  
  test("all Modules started", () {
    var context = new Context();
    var testModule1 = new TestModule(context);
    var testModule2 = new TestModule(context);
    var testModule3 = new TestModule(context);
    context.register("TestModule1", testModule1);
    context.register("TestModule2", testModule2);
    context.register("TestModule3", testModule3);
    context.start();
    
    expect(testModule1.started, equals(true));
    expect(testModule2.started, equals(true));
    expect(testModule3.started, equals(true));
  });
  
  test("multiple Modules stoped", () {
    var context = new Context();
    var testModule1 = new TestModule(context);
    var testModule2 = new TestModule(context);
    var testModule3 = new TestModule(context);
    context.register("TestModule1", testModule1);
    context.register("TestModule2", testModule2);
    context.register("TestModule3", testModule3);
    context.stop(["TestModule1", "TestModule2", "TestModule3"]);
    
    expect(testModule1.stopped, equals(true));
    expect(testModule2.stopped, equals(true));
    expect(testModule3.stopped, equals(true));
  });
  
  test("all Modules stoped", () {
    var context = new Context();
    var testModule1 = new TestModule(context);
    var testModule2 = new TestModule(context);
    var testModule3 = new TestModule(context);
    context.register("TestModule1", testModule1);
    context.register("TestModule2", testModule2);
    context.register("TestModule3", testModule3);
    context.stop();
    
    expect(testModule1.stopped, equals(true));
    expect(testModule2.stopped, equals(true));
    expect(testModule3.stopped, equals(true));
  });
}