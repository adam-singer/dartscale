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
  test("receives Message with data", () {
    var context = new Context();
    var received = null;
    
    var subscription = context.getStream("channel", "topic").listen((dynamic data){
      received = data;
    });
    
    context.emit("channel", "topic", "blabla");
    
    expect(received, equals("blabla"));
  });
}

