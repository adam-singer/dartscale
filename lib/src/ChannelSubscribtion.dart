part of dartscale;

class ChannelSubscribtion {
  
  Context _context;
  Function _onMessageHandler;
  String _channel;
  String _topic;
  bool paused;
  
  String get channel => this._channel;
  String get topic => this._topic;
  
  ChannelSubscribtion(Context this._context, String this._channel, 
      String this._topic, Function this._onMessageHandler);
  
  void message([dynamic data]) {
    if (data != null) {
      this._onMessageHandler(data);
    }
    else {
      this._onMessageHandler();
    }
    
  }
  
  void pause() {
    this.paused = true;
    this._context.pause(this);
  }
  
  void resume() {
    this.paused = false;
    this._context.resume(this);
  }
  
  void unsubscribe () {
    this._context.unsubscribe(this._channel, this._topic, this);
  }
}