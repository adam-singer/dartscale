part of example;

class ToDos {
  
  Sandbox _sandbox;
  
  DivElement _contentEl;
  Map<int, String> _todos = new Map<int, String> ();
  
  UListElement _todoList;
  
  ToDos ([Sandbox this._sandbox]);
  
  start([Map options]) {
    this._todos[1] = "Groceries: Banas and Apples";
    this._todos[2] = "Taxes: care about repays";
    this._todos[3] = "Take out trash";
    
    var html = ['<div id="module-todos">',
                  '<form>',
                    '<input type="text" class="input-medium">',
                    '<button type="submit" class="btn">Add</button>',
                  '</form>',
                  '<ul>',
                  '</ul>',
                '</div>'].join('');
    
    this._contentEl = new Element.html(html);
    options['containerEl'].append(this._contentEl);
    
    this._todoList = this._contentEl.query('ul');
    
    for (var key in this._todos.keys) {
      this._renderToDo(key);
    }
  }
  
  stop() {
    this._contentEl.remove();
  }
  
  _renderToDo(id) {
    var html = ['<li id="todo-', id,'">',
                  '<span>', this._todos[id], '</span>',
                  '<i class="icon icon-ok"></i>',
                  '<i class="icon icon-remove"></i>',
                '</li>'].join('');
    
    this._todoList.append(new Element.html(html));
  }
}