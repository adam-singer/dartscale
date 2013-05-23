library dartscale;

class Context {
  Map<String, Map<String, List<Module>>>  _subscriptions = new Map<String, Map<String, List<Module>>>();
  Map<String, Module>                     _modules = new Map<String, Module>();
  
  Map<String, Map<String, List<Module>>> get subscriptions => this._subscriptions;
  Map<String, Module>                    get modules => this._modules;
  
  void registerModule(String moduleId, Module module) {
    if (this._modules.containsKey(moduleId)) {
      throw new Exception("");
    }
    else {
      this._modules[moduleId] = module;
    }
  }
  
  void subscribe(String channel, String topic, String moduleId) {
    Module subscriber = this._modules[moduleId];
    if (subscriber == null) {
      throw new Exception("no module with id${moduleId} registered!");
    }
    
    final List<Module> subscriberList = this._getSubscriberList(channel, topic);
    if (!subscriberList.contains(subscriber)) {
      subscriberList.add(subscriber);
    }
    else {
      throw new Exception("module has already subscribed to channel:topic ${channel}:${topic}");
    }
  }
  
  void unsubscribe(String channel, String topic, String moduleId) {
    Module subscriber = this._modules[moduleId];
    if (subscriber == null) {
      throw new Exception("no module with id${moduleId} registered!");
    }
    
    final List<Module> subscriberList = this._getSubscriberList(channel, topic);
    if (subscriberList.contains(subscriber)) {
      subscriberList.remove(subscriber);
    }
    else {
      throw new Exception("module has already unsubscribed to channel:topic ${channel}:${topic}");
    }
  }
 
  void publish(String channel, String topic, data) {
    final List<Module> subscriberList = this._getSubscriberList(channel, topic);
    for (Module subscriber in subscriberList) {
      subscriber.onMessage(channel, topic, data);
    }
  }
  
  List<Module> _getSubscriberList(String channel, String topic) {
    Map<String, List<Module>> topicMap;
    if (_subscriptions.containsKey(channel)) {
      topicMap = _subscriptions[channel];
    }
    else {
      topicMap = new Map<String, List<Module>>();
      _subscriptions[channel] = topicMap;
    }
    
    List<Module> subscriberList;
    if (topicMap.containsKey(topic)) {
      subscriberList = topicMap[topic];
    }
    else {
      subscriberList = new List<Module>();
      topicMap[topic] = subscriberList;
    }
    
    return subscriberList;
  }
}

abstract class Module {
  
  Context context;
  
  Module(Context this.context);
  
  void onMessage(String channel, String topic, data);
  void onStop();
  void onDestroy();
  void onCreate();
  void onStart();
}