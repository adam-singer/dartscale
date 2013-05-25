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
  test("receives Message", () {
    var context = new Context();
    var received = null;
    
    var subscription = context.subscribe("channel", "topic", (dynamic data){
      received = data;
    });
    
    context.emit("channel", "topic", "blabla");
    
    expect(received, equals("blabla"));
  });
  
  test("subscription paused", () {
    var context = new Context();
    var received = null;
    
    var subscription = context.subscribe("channel", "topic", (dynamic data){
      received = data;
    });
    subscription.pause();
    
    context.emit("channel", "topic", "blabla");
    
    expect(received, equals(null));
  });
  
  test("subscription resumed", () {
    var context = new Context();
    var received = null;
    
    var subscription = context.subscribe("channel", "topic", (dynamic data){
      received = data;
    });
    subscription.resume();
    
    context.emit("channel", "topic", "blabla");
    
    expect(received, equals("blabla"));
  });
  
  test("subscription unsubscribed", () {
    var context = new Context();
    var received = null;
    
    var subscription = context.subscribe("channel", "topic", (dynamic data){
      received = data;
    });
    
    subscription.unsubscribe();
    
    context.emit("channel", "topic", "blabla");
    
    expect(received, equals(null));
  });
}

