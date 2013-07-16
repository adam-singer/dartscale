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
}

class TestPlugin {
  String testMethod (arg1, arg2) {
    return "${arg1}+${arg2}";
  }
}