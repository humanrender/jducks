var SidePanel = function(viewport, options){
  this.viewport = viewport;
  _.extend(this, _(options).pick("panel", "toggle"))
  this.panel = options.panel;
  this.options = _.extend(_(options).omit("panel"), this.defults);
  this.init();
};

_.extend(SidePanel.prototype, {
  defults:{
    visible_class: "side_panel_visible",
    hidden_class: "side_panel_hidden"
  },
  init:function(){
    this.set_event_handlers();
  },
  set_event_handlers:function(){
    _.bindAll(this, "on_touch", "on_viewport_touch");
    this.panel
      .on("mousedown", this.on_touch)
      .on("touchstart", this.on_touch);
  },
  on_touch:function(event){
    if(this.on_touch.last_called_by == "touchstart" && event.type == "mousedown"){
      this.on_touch.last_called_by = null;
      return;
    }
    this.on_touch.last_called_by = event.type;

    if(!this.viewport.hasClass(this.options.visible_class)){
      event.preventDefault();
      event.stopImmediatePropagation();
      this.show_panel();
    }
  },
  show_panel:function(){
    if(!this.viewport.hasClass(this.options.visible_class)){
      this.viewport
        .removeClass(this.options.hidden_class)
        .addClass(this.options.visible_class);
      _.defer($.proxy(function(){
        this.viewport
          .on("mousedown.hide_pannel_handler", this.on_viewport_touch)
          .on("touchstart.hide_pannel_handler", this.on_viewport_touch);
        this.toggle
          .on("mousedown.hide_pannel_handler", this.on_viewport_touch)
          .on("touchstart.hide_pannel_handler", this.on_viewport_touch);
      },this));
    }
  },
  on_viewport_touch:function(event){
    if(this.on_viewport_touch.last_called_by == "touchstart" && event.type == "mousedown"){
      this.on_viewport_touch.last_called_by = null;
      return;
    }
    var target = $(event.target);
    if(!target.closest(this.panel).length || target.is(this.toggle)){
      event.preventDefault();
      event.stopImmediatePropagation();
      this.hide_panel();
    }
  },
  hide_panel: function(){
    if(this.viewport.hasClass(this.options.visible_class)){
      this.viewport
        .removeClass(this.options.visible_class)
        .addClass(this.options.hidden_class)
        .off(".hide_pannel_handler");
      this.toggle
        .off(".hide_pannel_handler");
    }
  }
});
