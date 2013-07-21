import 'package:unittest/unittest.dart';
import '../lib/dartscale.dart';

void main () {
  test("Sandbox supports Function plugins", () {
    Sandbox.registerPlugin("testMethod", (arg1, arg2) {
      return "${arg1}+${arg2}";
    });
    
    var mediator = new Mediator();
    var sandbox = new Sandbox(mediator);
    
    var result = sandbox.testMethod("Hello", "World");
    expect(result, equals("Hello+World"));
  });
  
  test("Sandbox supports Object plugins", () {
    Sandbox.registerPlugin("SP", new TestPlugin());
    
    var mediator = new Mediator();
    var sandbox = new Sandbox(mediator);
    
    var result = sandbox.SP.testMethod("Hello", "World");
    expect(result, equals("Hello+World"));
  });
  
  test("Sandbox proxies Mediator", () {
    var mediator = new Mediator();
    var sandbox = new Sandbox(mediator);
    var receivedCount = 0;
    
    sandbox.channel("channel").topic("topic").listen((data){
      expect(data, equals("blabla"));
      receivedCount++;
    });
    
    sandbox.channel("channel").topic("topic").listen((data){
      expect(data, equals("blabla"));
      receivedCount++;
    });
    
    sandbox.channel("channel").topic("topic").add("blabla");
    
    expect(receivedCount, equals(2));
  });
}

class TestPlugin {
  String testMethod (arg1, arg2) {
    return "${arg1}+${arg2}";
  }
}