part of dartscale;



class MediatorTopic {
  
  StreamController _streamController = new StreamController.broadcast(sync: true);
  
  StreamSubscription listen(void onData(dynamic event), 
                            {void onError(error), void onDone(), bool cancelOnError}){
    return this._streamController.stream.listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }
  
  void add(dynamic event) {
    this._streamController.add(event);
  }
}

class MediatorChannel {
  
  var _topics = new Map<String, MediatorTopic>();
  
  MediatorTopic operator [](String topicName) {
    MediatorTopic topic = _topics[topicName];
    if (topic == null) {
      topic = new MediatorTopic();
      _topics[topicName] = topic;
    }
    
    return topic;
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