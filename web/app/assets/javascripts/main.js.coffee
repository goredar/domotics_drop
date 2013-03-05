resizeElements = ->
  $(".room").each ->
    $(this).height(0.6*$(this).width())
  $(".circle").each ->
    $(this).height($(this).width()) if $(this).width() != 0
    $(this).width($(this).height()) if $(this).height() != 0
$(window).resize(resizeElements).triggerHandler "resize"
$(resizeElements)