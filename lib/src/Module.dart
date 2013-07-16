part of dartscale;

abstract class Module {
  
  Sandbox sandbox;
  
  Module(Sandbox this.sandbox);
  
  void start(Map options);
  void stop();
  
}