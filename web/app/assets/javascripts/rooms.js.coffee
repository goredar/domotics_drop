resizeElements = ->
  $(".room").each ->
    $(this).height(0.6*$(this).width())
  $(".circle").each ->
    if $(this).is(".v-small-12, .v-small-6")
      $(this).width($(this).height())
    else
      $(this).height($(this).width())
    
$(window).resize(resizeElements).triggerHandler "resize"
$(resizeElements)