view =
  row_count: 4
  col_count: 6
  gutter_part: 0.04
  init: () ->
    # Show only first screen
    $(".screen:not(:first-child)").hide()
    window.onresize = () -> view.resize.call(view)
    @resize()
    @hook()
  # (Re)draw view on resize
  resize: () ->
    # Get window dimentions
    w_width = $(window).width()
    w_height = $(window).height()
    # Calculate size
    base_dim = Math.round(w_height / (@row_count + @gutter_part * (@row_count + 1)))
    gutter = Math.round(base_dim * @gutter_part)
    container_width = (base_dim + gutter)*@col_count
    # Layout
    $('body').height(w_height-gutter * 2).css('font-size', "#{base_dim / 2}px")
    $('.container').width(container_width)
    $('.spacer').width(w_width - container_width - gutter * 2).css('margin_right', gutter).css('margin_left', gutter)
    $('.column').width(base_dim+gutter)
    $('.column-2x').width( (base_dim + gutter ) * 2)
    # Column(-1x) elements
    $('.square').width(base_dim).height(base_dim).css('margin_right', gutter)
    $('.rectangle').width(base_dim).height(base_dim * 2 + gutter)
    # Column-2x elements
    $('.square-1x').width(base_dim).height(base_dim).css('margin_right', gutter)
    $('.square-2x').width(base_dim * 2 + gutter).height(base_dim * 2 + gutter)
    $('.rectangle-land').width(base_dim * 2 + gutter).height(base_dim)
    $('.rectangle-port').height(base_dim * 2 + gutter).width(base_dim).css('margin_right', gutter)
    $('.cam_shot').width(base_dim * 5 + gutter * 4)
    # All elements
    $("[class*=square], [class*=rectangle]").css('margin_bottom', gutter)
  rotate: (direction) ->
    $(".screen").each () ->
      if $(this).is(":visible")
        $(this).hide()
        if direction
          next_screen = $(this).next(".screen")
        else
          next_screen = $(this).prev(".screen")
        if next_screen.size() == 1
          next_screen.show()
        else
          if direction
            $(".screen").first().show()
          else
            $(".screen").last().show()
        return false
      return true
  hook: () ->
    if !!$.os.phone or !!$.os.tablet
      hook_action = "tap"
    else
      hook_action = "click"
    # Hook element's commands
    $(document).on hook_action, "[data-command]", () ->
      screen = $(this).closest('.screen')
      if screen.size() == 1
        request = "/#{$(this).closest('.screen').attr('id')}"
      else
        request = ""
      request += "/#{$(this).attr('id')}" if $(this).attr("id")
      request += "/#{$(this).data('command')}.json"
      $.getJSON request, rooms.update
      return false
    # Hook spacer
    spacer = $(".spacer .room_switch")
    $(document).on hook_action, spacer.first(), () ->
      view.rotate(true)
      return false
    $(document).on hook_action, spacer.last(), () ->
      view.rotate(false)
      return false
    # Hook screen's and dialog's links
    $(document).on hook_action, "[data-screen]", () ->
      $(this).closest('.screen, .dialog').hide()
      $("##{$(this).data('screen')}").show()
      return false

rooms =
  # Get initial state
  init: () ->
    $(".screen").each ->
      $.getJSON "#{$(this).attr("id")}/state.json", rooms.update
  # Update elements state and info
  update: (data, status, xhr) ->
    if status == "success"
      #console.log data
      for room_name, room_data of data
        for element_name, element_data of room_data.elements
          # Add element state class
          element = $("##{room_name} ##{element_name} div")
          element.removeClass()
          element.addClass(element_data.state)
          # Add element info span
          if element_data.info
            element_info = element.children(".info")
            if element_info.size() != 0
              element_info.html(element_data.info)
            else
              element.append("<span class='info'>#{element_data.info}</span>")
          if element_data.img
            element_img = element.children("img")
            if element_img.size() != 0
              element_img.attr('src', element_data.img)
            else
              element.append("<img width=100% src=#{element_data.img}></img>")
wsclient =
  init: () ->
    Socket = if "MozWebSocket" in window then MozWebSocket else WebSocket
    ws = new Socket("wss://#{window.location.host}/websocket/connect")
    ws.onmessage = (msg) ->
      $.getJSON "#{msg.data}/state.json", rooms.update
$ ->
  rooms.init()
  view.init()
  wsclient.init()