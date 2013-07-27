part of example;

class ToDos {
  
  Sandbox _sandbox;
  
  DivElement _contentEl;
  int _nextToDoId = 0;
  
  UListElement _todoList;
  
  ToDos ([Sandbox this._sandbox]);
  
  start([Map options]) {
    this._initLocalStorage();
    
    var html = ['<div id="module-todos">',
                  '<form>',
                    '<input type="text" class="input-medium">',
                    '<button type="submit" class="btn">Add</button>',
                  '</form>',
                  '<ul>',
                  '</ul>',
                '</div>'].join('');
    
    this._contentEl = new Element.html(html);
    this._todoList = this._contentEl.query('ul');
    
    options['containerEl'].append(this._contentEl);
    
    window.localStorage.keys.forEach((key) => this._renderToDo(key));
    
    this._setupEvents();
    
    this._sandbox.channel('navigationbar').topic('filter').listen((filterContent) {
      this._filter(filterContent);
    });
    
    this._sandbox.channel('navigationbar').topic('clearfilter').listen((filterContent) {
      this._todoList.queryAll('li span').forEach((element) => element.parent.classes.remove('invisible'));
    });
  }
  
  stop() {
    this._contentEl.remove();
  }
  
  _initLocalStorage() {
    if (window.localStorage.keys.length == 0) {
      var map = {
        "1": {
          "subject": "Groceries: Banas and Apples",
          "isDone": false
        },
        "2": {
          "subject": "Taxes: take care of them",
          "isDone": false
        },
        "3": {
          "subject": "Bring out trash",
          "isDone": false
        }  
      };
      
      for (var key in map.keys) {
        window.localStorage[key] = stringify(map[key]);
        this._nextToDoId++;
      }
    }
    else {
      for (var key in window.localStorage.keys) {
        var intKey = int.parse(key);
        
        if (intKey > this._nextToDoId) {
          this._nextToDoId = intKey;
        }
        
        this._nextToDoId++;
      }
    }
  }
  
  _setupEvents() {
    var input = this._contentEl.query('input');
    
    input.onKeyDown.listen((event) {
      if (event.keyCode == KeyCode.ENTER) {
        event.preventDefault();
        
        this._addToDo(input.value);
        input.value = '';
      }
    });
    
    this._contentEl.query('button[type="Submit"]').onClick.listen((event) {
      event.preventDefault();
      
      if (input.value.length > 0) {
        this._addToDo(input.value);
        input.value = '';
      }
    });
    
    this._todoList.onClick.listen((MouseEvent event) {
      var el = event.target;
      
      if (el.classes.contains('icon-remove')) {
        this._deleteToDo(el.parent);
      }
      else if (el.classes.contains('icon-ok')) {
        this._toggleToDoDone(el.parent);
      }
    });
  }
  
  _renderToDo(id) {
    var todoObject = parse(window.localStorage[id.toString()]);
    
    var html = ['<li class="record-todo ', todoObject["isDone"]?"done":"",'" data-id="', id,'">',
                  '<span>', todoObject["subject"], '</span>',
                  '<i class="icon icon-ok"></i>',
                  '<i class="icon icon-remove"></i>',
                '</li>'].join('');
    
    this._todoList.append(new Element.html(html));
  }

  _addToDo(text) {
    var todoJson = stringify({
      "subject": text,
      "done": false
    });
    
    window.localStorage[this._nextToDoId.toString()] = todoJson;
    this._renderToDo(this._nextToDoId);
    
    this._nextToDoId++;
  }
  
  _deleteToDo(todoLIElement) {
    window.localStorage.remove(todoLIElement.dataset["id"]);
    
    todoLIElement.remove();
  }
  
  _toggleToDoDone(todoLIElement) {
    var done = !todoLIElement.classes.contains('done'); 
    var id = todoLIElement.dataset["id"];
    var todoObject = parse(window.localStorage[id]);
    todoObject["isDone"] = done;
    window.localStorage[id] = stringify(todoObject);
    
    if (done) {
      todoLIElement.classes.add('done');
    }
    else {
      todoLIElement.classes.remove('done');
    }
    
  }
  
  _filter(content) {
    this._todoList.queryAll('li span').forEach((element) {
      if (element.innerHtml.contains(content)) {
        element.parent.classes.remove('invisible');
      }
      else {
        element.parent.classes.add('invisible');
      }
    });
  }
}