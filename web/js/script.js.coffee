# Base sizes
row_count = 4
col_count = 6
gutter_part = 0.04
base_dim = 0
gutter = 0

# (Re)draw view
DrawBlocks = () ->
  # Get window dimentions
  w_width = $(window).width()
  w_height = $(window).height()
  base_dim = Math.round(w_height/row_count/(1+gutter_part))
  gutter = Math.round(base_dim*gutter_part)
  #col_count = $('.column').size()+$('.column-2x').size()*2
  # Set global sizes
  $('body').height(w_height-gutter*2)
  $('body').css('font-size', "#{base_dim/2}px")
  # Set coluns
  container_width = (base_dim+gutter)*col_count
  $('.container').width(container_width)
  $('.spacer').width(w_width-container_width-gutter*2).css('margin_right', gutter).css('margin_left', gutter)
  $('.column').width(base_dim+gutter)
  $('.column-2x').width((base_dim+gutter)*2)
  # Column(-1x) elements
  $('.square').width(base_dim).height(base_dim).css('margin_bottom', gutter).css('margin_right', gutter)
  $('.rectangle').width(base_dim).height(base_dim*2+gutter)
  # Column-2x elements
  $('.square-1x').width(base_dim).height(base_dim).css('margin_right', gutter)
  $('.square-2x').width(base_dim*2+gutter).height(base_dim*2+gutter)
  $('.rectangle-land').width(base_dim*2+gutter).height(base_dim)
  $('.rectangle-port').height(base_dim*2+gutter).width(base_dim).css('margin_right', gutter)
  # Margins for elements
  $('.column, .column-2x').children().css('margin_bottom', gutter)

# (Re)draw elements state and info
PullElements = (data, status, xhr)->
  if status == "success"
    $.each data, (room_name, room_data)->
      $.each room_data["elements"], (element_name, element_data)->
        element = $("##{room_name} ##{element_name} div")
        element.removeClass()
        element.addClass(element_data["state"])
        if element_data["info"]
          element = $("##{room_name} ##{element_name} .info")
          unless element.size() == 0
            element.html(element_data["info"])
          else
            $("##{room_name} ##{element_name}").append("<span class='info'>#{element_data['info']}</span>")

# Get initial state
$(".screen").each ->
  $.getJSON "#{$(this).attr("id")}/state", PullElements

# Hook click events
$(document).on "click", "[data-command]", ()->
  screen = $(this).closest('.screen')
  if screen.size() == 1
    request = "/#{$(this).closest('.screen').attr('id')}"
  else
    request = ""
  request += "/#{$(this).attr('id')}" if $(this).attr("id")
  request += "/#{$(this).data('command')}"
  $.getJSON request, PullElements
  return false

# Hook spacer's click
$(document).on "click", ".spacer", ()->
  $(".screen").each ()->
    if $(this).is(":visible")
      $(this).hide()
      next_screen = $(this).next(".screen")
      if next_screen.size() == 1
        next_screen.show()
      else
        $(".screen").first().show()
      return false
    return true
  return false

$(document).on "click", "[data-screen]", ()->
  $(this).closest('.screen, .dialog').hide()
  $("##{$(this).data('screen')}").show()

# Show only first screen
$(".screen:not(:first-child)").hide()
DrawBlocks()
window.onresize = DrawBlocks