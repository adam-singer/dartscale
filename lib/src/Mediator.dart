part of dartscale;

class MediatorChannel {
  
  var _topics = new Map<String, StreamController>();
  
  StreamController operator [](String topicName) {
    StreamController stream = _topics[topicName];
    if (stream == null) {
      stream = new StreamController();
      _topics[topicName] = stream;
    }
    
    return stream;
  }
}

class Mediator {
  
  var _channels = new Map<String, MediatorChannel>();
  
  MediatorChannel operator [](String channelName) {
    var channel = _channels[channelName];
    if (channel == null) {
      channel = new MediatorChannel();
      _channels[channelName] = channel;
    }
    
    return channel;
  }
}