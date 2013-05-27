part of dartscale;

abstract class Module {
  
  Context context;
  
  Module(Context this.context);
  
  void onStop() {}
  void onUnregister() {}
  void onRegister() {}
  void onStart() {}
}