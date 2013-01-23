jQuery(document).ready(function () {
  $("a.modify-name").click(function() {
    $(this).addClass("disabled");
    $("div.new-name", $(this).parent()).show("slow");
  })
  
  $("a.remove-section").click(function() {
    title = $(this).attr("id").replace("remove-", "")
    $.ajax({
      url: "/clients/delete",
      data: {title: title},
      type: "POST",
      complete: function(){ $("div#" + title).slideUp("500", function(){ $("div#" + title).remove() }) } 
    })    
  })
  function valid(e, reg) {
    if(e.val().match(reg)) {
      e.parents('.control-group').removeClass('error').addClass('verified');
    }
    else {
      e.parents('.control-group').removeClass('verified').addClass('error');
    }
  }
  function validAll(){
    $("select:visible").each(function(){
      if($(this).val()) {
        $(this).parents('.control-group').removeClass('error').addClass('verified');
      }
      else {
        $(this).parents('.control-group').removeClass('verified').addClass('error');
      } 
    })
    $("input:visible").each(function(i, e){
      var name = $(e).attr("name")
      if (name.match(/_title/))
        valid($(e), /^[A-Za-z]\w+$/);
      else if(name.match(/ServerHostPort|IntervalTime/))
        valid($(e), /^\d+$/);
      else if(name.match(/Password/))
        valid($(e), /^.+$/)
      else
        valid($(e), /^\S+$/)      
    })
  }
  $("form.form-horizontal button[type='submit']").click(function(event){
    event.preventDefault();
    validAll();
    if($('div.control-group:visible').size() == $('div.verified:visible').size() )
      { $("form.form-horizontal").submit()}
    else
      { alert("Incorrect data. Please check your form.")}
  })
  function xadapt(fre){
    switch(fre) {
      case 'interval': 
        $('div#execute-date,div#execute-time').hide();
        $('div#interval').slideDown('500');
        break;
      case 'daily':
        $('div#interval,div#execute-date').slideUp('200');
        $('div#execute-time').slideDown('500');
        break;
      case 'weekly':
        $('div#interval').hide();
        $('div#execute-date .controls *').remove();
        $('div#execute-date .controls').prepend($('#select-weekday').html())
        $('div#execute-date,div#execute-time').slideDown("500");
        break;
      case 'once':
        $('div#interval').hide();
        $('div#execute-date .controls *').remove();
        $("div#execute-date .controls").prepend($('#once-date').html())
        $("input.datepicker").datepicker({format: 'yyyy-mm-dd'})
        $('div#execute-date,div#execute-time').slideDown("500");
        break;
      case 'monthly':
        $('div#interval').hide();
        $('div#execute-date .controls *').remove();
        $("div#execute-date .controls").prepend($('#select-monthday').html())
        $('div#execute-date,div#execute-time').slideDown("500");
        break;
      case 'blank':
        $('#interval, #execute-date, #execute-time').slideUp("200");
    }
  }
  $(function(){
    if($('div#frequence select')[0]){
      xadapt($("div#frequence select").val()); 
      }
  })
  $("div#frequence select").change(function() {
    xadapt($(this).val());
  })
  $("a.remove-section").popover()
  $("button.destroy-schedule").popover()
  $("input.datepicker").datepicker({format: 'yyyy-mm-dd'})
  $('.timepicker').timepicker({
    defaultTime: 'value',
    showMeridian: false
  })
  $('a.add-time').click(function() { 
    $('div#execute-time .controls').append($("#add-time").html());
    $('div#execute-time p').last().slideDown('500');
    $('div#execute-time p .timepicker').timepicker({showMeridian: false})
    $('a.remove-time').click(function(){$(this).parent().slideUp('200', $(this).parent().remove())})
  })
  $('a.remove-time').click(function(){
    $(this).parent().remove()
  })
})
