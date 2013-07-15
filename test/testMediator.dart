import 'package:unittest/unittest.dart';
import '../lib/dartscale.dart';

void main () {
  test("receives Message with data", () {
    var core = new Core();
    var received = null;
    
    core.mediator["channel"]["topic"].listen((data){
      expect(data, equals("blabla"));
    });
    
    core.mediator["channel"]["topic"].listen((data){
      expect(data, equals("blabla"));
    });
    
    core.mediator["channel"]["topic"].add("blabla");
  });
}

