part of dartscale;

class ChannelSubscribtion {
  
  Context _context;
  Function _onMessageHandler;
  String _channel;
  String _topic;
  bool paused;
  
  ChannelSubscribtion(Context this._context, String this._channel, 
      String this._topic, Function this._onMessageHandler);
  
  void message(dynamic data) {
    this._onMessageHandler(data);
  }
  
  void pause() {
    this.paused = true;
  }
  
  void resume() {
    this.paused = false;
  }
  
  void unsubscribe () {
    this._context.unsubscribe(this._channel, this._topic, this);
  }
}