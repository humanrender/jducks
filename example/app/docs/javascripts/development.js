$(window).load(function(){

      // Vertical grid properties
  var vincrement = 12, 
      vgrid_color = "#ce0", 
      vopacity = 0.2,

      // Vertical grid container
      vcontainer = $("<div id='v-grid-container'></div>");

  $("body").append(vcontainer.css({
    "-webkit-user-select":"none"
  }));

  var build_vertical_grid = function(increment, color, opacity){
    var wheight = $("body").height(),
        y = 0,
        grid;
    
    while(y < wheight){
      y += increment;
      grid = $("<span></span>");
      vcontainer.append(grid);
      grid.css({
        "border-bottom":"1px solid "+color,
        position:"absolute",
        top:y+"px",
        left:0,
        width:"100%",
        "-webkit-user-select":"none",
        opacity:opacity
      })
    }
  }

  build_vertical_grid(vincrement, vgrid_color, vopacity);

  $(window).on("resize", function(){
    vcontainer.html("")
    build_vertical_grid(vincrement, vgrid_color, vopacity);
  })
})
;
