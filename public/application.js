jQuery(document).ready(function () {
  $("a.modify-name").click(function() {
    $(this).addClass("disabled")
    $(this).parent().children().select("div.hide").show("slow");
  })
  
  $("a.remove-section").click(function() {
    title = $(this).attr("id").replace("remove-", "")
    $.ajax({
      url: "/delete",
      data: {title: title},
      type: "POST",
      complete: function(){ $("div#" + title).slideUp("500", function(){ $("div#" + title).remove() }) } 
    })    
  })
  $("a.remove-section").popover()
})
