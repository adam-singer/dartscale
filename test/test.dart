import 'package:unittest/unittest.dart';
import '../lib/dartscale.dart';

class TestModule extends Module {
  
  var lastReceivedMessage;
  
  void onMessage(String channel, String topic, data) {
    this.lastReceivedMessage = data;
  }
  
  TestModule(Context context):super(context);
}

void main () {
  test("Module registered", () {
    var context = new Context();
    var testModule = new TestModule(context);
    context.registerModule("TestModule", testModule);
    
    expect(context.modules.containsKey("TestModule"), equals(true));
  });
  
  test("Module subscribed", () {
    var context = new Context();
    var testModule = new TestModule(context);
    context.registerModule("TestModule", testModule);
    context.subscribe("channel1", "topic1", "TestModule");
    context.subscribe("channel2", "topic2", "TestModule");
    
    var subscribedModules = context.subscriptions["channel1"]["topic1"];
    expect(subscribedModules.contains(testModule), equals(true));
    subscribedModules = context.subscriptions["channel2"]["topic2"];
    expect(subscribedModules.contains(testModule), equals(true));
  });
  
  test("Module unsubscribed", () {
    var context = new Context();
    var testModule = new TestModule(context);
    context.registerModule("TestModule", testModule);
    context.subscribe("channel1", "topic1", "TestModule");
    context.subscribe("channel2", "topic2", "TestModule");
    context.unsubscribe("channel1", "topic1", "TestModule");
    context.unsubscribe("channel2", "topic2", "TestModule");
    
    var subscribedModules = context.subscriptions["channel1"]["topic1"];
    expect(subscribedModules.contains(testModule), equals(false));
    subscribedModules = context.subscriptions["channel2"]["topic2"];
    expect(subscribedModules.contains(testModule), equals(false));
    
    var data1 = "data1";
    context.publish("channel1", "topic1", data1);
    expect(testModule.lastReceivedMessage, equals(null));
    
    var data2 = "data2";
    context.publish("channel2", "topic2", data2);
    expect(testModule.lastReceivedMessage, equals(null));
  });
  
  test("Module received Message", () {
    var context = new Context();
    var testModule = new TestModule(context);
    context.registerModule("TestModule", testModule);
    context.subscribe("channel1", "topic1", "TestModule");
    context.subscribe("channel2", "topic2", "TestModule");
    
    var data1 = "data1";
    context.publish("channel1", "topic1", data1);
    expect(testModule.lastReceivedMessage, equals(data1));
    
    var data2 = "data2";
    context.publish("channel2", "topic2", data2);
    expect(testModule.lastReceivedMessage, equals(data2));
    
  });
}

