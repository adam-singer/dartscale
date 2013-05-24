part of dartscale;

abstract class Module {
  
  Context context;
  
  Module(Context this.context);
  
  void onMessage(String channel, String topic, data);
  void onStop();
  void onUnregister();
  void onRegister();
  void onStart();
}