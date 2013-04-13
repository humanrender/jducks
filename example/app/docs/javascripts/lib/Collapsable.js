var Collapsable = function(el){
  _.bindAll(this,"on_toggle");
  this.element = $(el);
  this.element.on("click", "[data-toggle]", this.on_toggle);
}

_.extend(Collapsable.prototype, {
  on_toggle:function(event){
    event.preventDefault();
    this.toggle();
  },
  toggle:function(){
    this.element.toggleClass("expanded")
  }
})
;
