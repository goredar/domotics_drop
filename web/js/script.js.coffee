# (Re)draw view
DrawBlocks = () ->
  # Get window dimentions
  w_width = $(window).width()
  w_height = $(window).height()
  # Base sizes
  gutter = Math.round(w_height/100)
  row_count = 4
  base_dim = Math.round((w_height-row_count*gutter)/row_count)
  col_count = 6
  #col_count = $('.column').size()+$('.column-2x').size()*2
  # Set global sizes
  $('html').width(w_width).height(w_height)
  $('body').width((base_dim+gutter)*col_count).height(w_height-gutter)
  $('body').css('font-size', "#{base_dim/2}px")
  # Set coluns
  $('.column').width(base_dim+gutter).height('100%')
  $('.column-2x').width((base_dim+gutter)*2).height('100%')
  # Column(-1x) elements
  $('.square').width(base_dim).height(base_dim)
  $('.rectangle').width(base_dim).height(base_dim*2+gutter)
  # Column-2x elements
  $('.square-1x').width(base_dim).height(base_dim).css('margin_right', gutter)
  $('.square-2x').width(base_dim*2+gutter).height(base_dim*2+gutter)
  $('.rectangle-land').width(base_dim*2+gutter).height(base_dim)
  $('.rectangle-port').height(base_dim*2+gutter).width(base_dim).css('margin_right', gutter)
  # Margins for elements
  $('.column, .column-2x').children().css('margin_bottom', gutter)
  $('.column, .column-2x').children('*:last-child').css('margin_bottom', 0)
# (Re)draw elements state and info
PutElements = (data, status, xhr)->
  if status = "success"
    $.each data, (room_name, room_data)->
      $.each room_data["elements"], (element_name, element_data)->
        element = $("##{room_name} ##{element_name} div")
        element.removeClass()
        element.addClass("#{element_data["state"]}")
# Get initial state
$(".screen").each ->
  $.getJSON "#{$(this).attr("id")}/state", PutElements

$(document).on "click", "[data-command]", ()->
  request = "/#{$(this).closest('.screen').attr('id')}"
  request += "/#{$(this).attr('id')}" if $(this).attr("id")
  request += "/#{$(this).data('command')}"
  $.getJSON request, PutElements
DrawBlocks()
window.onresize = DrawBlocks