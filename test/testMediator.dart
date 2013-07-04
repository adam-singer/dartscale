import 'package:unittest/unittest.dart';
import '../lib/dartscale.dart';

void main () {
  test("receives Message with data", () {
    var core = new Core();
    var received = null;
    
    var subscription = core.mediator["channel"]["topic"].stream.listen((data){
      expect(data, equals("blabla"));
    });
    
    core.mediator["channel"]["topic"].add("blabla");
  });
}

