library example;

import 'dart:html';
import '../../lib/dartscale.dart';

part 'modules/Navigationbar.dart';
part 'modules/ToDos.dart';

main () {
  var core = new Core();
  core.register(new Navigationbar());
  core.register(new ToDos());
  
  core.start("Navigationbar", "Navigationbar", {
    "containerEl": query('.navbar-fixed-top')
  });
  
  core.start("ToDos", "ToDos", {
    "containerEl": query('body > .container')
  });
}