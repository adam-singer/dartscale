import 'package:unittest/unittest.dart';
import '../lib/dartscale.dart';

void main () {
  test("Mediator supports multiple subscribers", () {
    var mediator = new Mediator();
    var receivedCount = 0;
    
    mediator.channel("channel").topic("topic").listen((data){
      expect(data, equals("blabla"));
      receivedCount++;
    });
    
    mediator.channel("channel").topic("topic").listen((data){
      expect(data, equals("blabla"));
      receivedCount++;
    });
    
    mediator.channel("channel").topic("topic").add("blabla");
    
    expect(receivedCount, equals(2));
  });
  
  test("Subscribers can pause", () {
    var mediator = new Mediator();
    var receivedCount = 0;
    
    var subscription = mediator.channel("channel").topic("topic").listen((data){
      expect(data, equals("blabla"));
      receivedCount++;
    });
    subscription.pause();
    
    subscription = mediator.channel("channel").topic("topic").listen((data){
      expect(data, equals("blabla"));
      receivedCount++;
    });
    subscription.pause();
    
    mediator.channel("channel").topic("topic").add("blabla");
    
    expect(receivedCount, equals(0));
  });
  
  test("Subscribers can resume", () {
    var mediator = new Mediator();
    var receivedCount = 0;
    
    var subscription = mediator.channel("channel").topic("topic").listen((data){
      expect(data, equals("blabla"));
      receivedCount++;
    });
    subscription.pause();
    subscription.resume();
    
    subscription = mediator.channel("channel").topic("topic").listen((data){
      expect(data, equals("blabla"));
      receivedCount++;
    });
    subscription.pause();
    subscription.resume();
    
    mediator.channel("channel").topic("topic").add("blabla");
    
    expect(receivedCount, equals(2));
  });
}

