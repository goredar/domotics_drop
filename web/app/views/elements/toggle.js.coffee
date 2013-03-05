$("#main_lights").html("<%=j render partial: 'rooms/playroom/main_lights', object: @element %>")
$(".circle").each ->
  if $(this).is(".v-small-12, .v-small-6")
    $(this).width($(this).height())
  else
    $(this).height($(this).width())