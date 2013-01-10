jQuery(document).ready(function () {
  $("a.modify-name").click(function() {
    $(this).addClass("disabled");
    $("div.new-name", $(this).parent()).show("slow");
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
  function valid(e, reg) {
    if(e.val().match(reg)) {
      e.parents('.control-group').removeClass('error').addClass('verified');
      if($('div.control-group').size() == $('div.verified').size() ) { $("button[type='submit']").removeClass('disabled').removeAttr('disabled') }
    }
    else {
      e.parents('.control-group').removeClass('verified').addClass('error');
      $("button[type='submit']").addClass('disabled').attr('disabled','true') 
    }
  }
  $("input").blur(function() {
    var name = $(this).attr("name")
    if (name.match(/_title/))
      valid($(this), /^[A-Za-z]\w+$/);
    else if(name.match(/ServerHostPort|IntervalTime/))
      valid($(this), /^\d+$/);
    else if(name.match(/Password/))
      valid($(this), /^.+$/)
    else
      valid($(this), /^\S+$/)
  })

  function xadapt(fre){
    switch(fre) {
      case 'interval': 
        $('div#execute-date,div#execute-time').hide().addClass('verified');
        $('div#interval').slideDown('500').removeClass('verified');
        break;
      case 'daily':
        $('div#interval,div#execute-date').slideUp('200').addClass('verified');
        $('div#execute-time').slideDown('500').removeClass('verified')
        break;
      case 'weekly':
        $('div#interval').hide().addClass('verified');
        $('div#execute-date .controls *').remove();
        $('div#execute-date .controls').prepend($('#select-weekday').html())
        $('div#execute-date,div#execute-time').slideDown("500");
        $('div#execute-date select').change(function(){
          if($(this).val()) {
            $(this).parents('.control-group').removeClass('error').addClass('verified');
            if($('div.control-group').size() == $('div.verified').size() ) { $("button[type='submit']").removeClass('disabled').removeAttr('disabled') }
          }
          else {
            $(this).parents('.control-group').removeClass('verified').addClass('error');
            $("button[type='submit']").addClass('disabled').attr('disabled','true') 
          }
        })
        break;
      case 'once':
        $('div#interval').hide().addClass('verified');
        $('div#execute-date .controls *').remove();
        $("div#execute-date .controls").prepend($('#once-date').html())
        $("input.datepicker").datepicker({format: 'yyyy-mm-dd'})
        $("input.datepicker").blur(function(){ valid($(this), /^\d{4}-\d{2}-\d{2}$/)})
        $('div#execute-date,div#execute-time').slideDown("500").removeClass('verified');
        break;
      case 'monthly':
        $('div#interval').hide().addClass('verified');
        $('div#execute-date .controls *').remove();
        $("div#execute-date .controls").prepend($('#select-monthday').html())
        $('div#execute-date,div#execute-time').slideDown("500");
        $('div#execute-date select').change(function(){
          if($(this).val()) {
            $(this).parents('.control-group').removeClass('error').addClass('verified');
            if($('div.control-group').size() == $('div.verified').size() ) { $("button[type='submit']").removeClass('disabled').removeAttr('disabled') }
          }
          else {
            $(this).parents('.control-group').removeClass('verified').addClass('error');
            $("button[type='submit']").addClass('disabled').attr('disabled','true') 
          }
        })
        break;
      case 'blank':
        $('#interval, #execute-date, #execute-time').slideUp("200");
    }
  }
  $(function(){
    if($('div#frequence select')[0])
      { xadapt($("div#frequence select").val()) }
  })
  $("div#frequence select").change(function() {
    xadapt($(this).val());
    $("button[type='submit']").addClass('disabled').attr('disabled','true')
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
