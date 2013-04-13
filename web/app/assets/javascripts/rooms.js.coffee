# NEW namespace
window.domoticsGO = {}
# Resize room view and circles
window.domoticsGO.resizeElements = ->
  $(".room").each ->
    $(this).height(0.5*$(this).width())
  $(".circle").each ->
    if $(this).is(".v-small-12, .v-small-6")
      $(this).width($(this).height())
    else
      $(this).height($(this).width())
# Set trigger for resize
$(window).resize(window.domoticsGO.resizeElements).triggerHandler "resize"
# Update room view
window.domoticsGO.updateRoom = ->
  $(".updatable").each ->
    $.getScript('/rooms/'+$(this).attr('data-id')+'/'+$(this).attr('data-time')+'.js')
# Poll for changes
setInterval ->
  window.domoticsGO.updateRoom()
, 1000