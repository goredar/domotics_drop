resizeElements = ->
  $(".room").each ->
    $(this).height(0.6*$(this).width())
  $(".circle").each ->
    $(this).height($(this).width())
  $(".circle_inline").each ->
    $(this).width($(this).height())
$(window).resize(resizeElements).triggerHandler "resize"
$(resizeElements)