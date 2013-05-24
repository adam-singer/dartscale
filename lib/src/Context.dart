part of dartscale;

class Context {
  Map<String, Module>                     _modules = new Map<String, Module>();
  Map<String, Module>                    get modules => this._modules;
  
  Map<String, Map<String, List<ChannelSubscribtion>>> _subscriptions = new Map<String, Map<String, List<ChannelSubscribtion>>>();
  Map<String, Map<String, List<ChannelSubscribtion>>> get subscriptions => this._subscriptions;
  
  void register(String moduleId, Module module) {
    if (this._modules.containsKey(moduleId)) {
      throw new Exception("module with id ${moduleId} already registered");
    }
    else {
      this._modules[moduleId] = module;
      module.onRegister();
    }
  }
  
  void unregister(String moduleId) {
    if (!this._modules.containsKey(moduleId)) {
      throw new Exception("no module with id ${moduleId} registered");
    }
    else {
      this._modules[moduleId].onUnregister();
      this._modules.remove(moduleId);
    }
  }
  
  void start(modules) {
    var ids = new List<String>();
    if (modules is String) {
      ids.add(modules);
    }
    else if (modules is List) {
      ids = modules;
    }
    else {
      throw new TypeError("only List<String> and String arguments are allowed");
    }
    
    for (String moduleId in ids) {
      if (this._modules.containsKey(moduleId)) {
        this._modules[moduleId].onStart();
      }
    }
  }
  
  void stop(modules) {
    var ids = new List<String>();
    if (modules is String) {
      ids.add(modules);
    }
    else if (modules is List) {
      ids = modules;
    }
    else {
      throw new TypeError("only List<String> and String arguments are allowed");
    }
    
    for (String moduleId in ids) {
      if (this._modules.containsKey(moduleId)) {
        this._modules[moduleId].onStop();
      }
    }
  }
  
  ChannelSubscribtion subscribe(String channel, String topic, Function onMessageHandler) {
    final ChannelSubscribtion subscription = new ChannelSubscribtion(this, channel, topic, onMessageHandler);
    this._getSubscriberList(channel, topic).add(subscription);
    
    return subscription;
  }
  
  void unsubscribe(String channel, String topic, ChannelSubscribtion subscription) {
    final List<ChannelSubscribtion> subscriberList = this._getSubscriberList(channel, topic);
    if (subscriberList.contains(subscription)) {
      subscriberList.remove(subscription);
    }
  }
 
  void emit(String channel, String topic, dynamic data) {
    final List<ChannelSubscribtion> subscriberList = this._getSubscriberList(channel, topic);
    for (ChannelSubscribtion subscriber in subscriberList) {
      if (!subscriber.paused) {
        subscriber.message(data);
      }
    }
  }
  
  List<ChannelSubscribtion> _getSubscriberList(String channel, String topic) {
    Map<String, List<ChannelSubscribtion>> topicMap;
    if (_subscriptions.containsKey(channel)) {
      topicMap = _subscriptions[channel];
    }
    else {
      topicMap = new Map<String, List<ChannelSubscribtion>>();
      _subscriptions[channel] = topicMap;
    }
    
    List<ChannelSubscribtion> subscriberList;
    if (topicMap.containsKey(topic)) {
      subscriberList = topicMap[topic];
    }
    else {
      subscriberList = new List<ChannelSubscribtion>();
      topicMap[topic] = subscriberList;
    }
    
    return subscriberList;
  }
}