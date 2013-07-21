part of example;

class Navigationbar {
  
  Sandbox _sandbox;
  Element _contentEl;
  
  Navigationbar ([Sandbox this._sandbox]);
  
  start([Map options]) {
    var html = ['<form id="module-navigationbar" class="navbar-form pull-right">',
                  '<input type="text" placeholder="search in todos..." class="input-medium search-query">',
                  '<button type="submit" class="btn btn-small">Search</button>',
                '</form>'].join('');
    this._contentEl = new Element.html(html);
    
    options['containerEl'].query('.container').append(this._contentEl);
    
    this.setupSearchForm();
  }
  
  stop() {
    this._contentEl.remove();
  }
  
  setupSearchForm() {
    var iptSearch = this._contentEl.query('input');
    var btnSubmit = this._contentEl.query('button');
    
    btnSubmit.onClick.listen((MouseEvent event) {
      event.preventDefault();
      
      this._sandbox.channel('navigationbar').topic('search').add(iptSearch.value);
      iptSearch.value = '';
    });
  }
}