resizeRoom = ->
  $(".room").each ->
   $(this).height(0.6*$(this).width())

$(window).resize(resizeRoom).triggerHandler "resize"
  