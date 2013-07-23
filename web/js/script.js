(function() {
  var DrawBlocks, DrawElements;

  DrawBlocks = function() {
    var base_dim, col_count, gutter, row_count, w_height, w_width;
    w_width = $(window).width();
    w_height = $(window).height();
    gutter = Math.round(w_height / 100);
    row_count = 4;
    col_count = 6;
    base_dim = Math.round((w_height - row_count * gutter) / row_count);
    $('html').width(w_width).height(w_height);
    $('body').width((base_dim + gutter) * col_count).height(w_height - gutter);
    $('.column').width(base_dim + gutter).height('100%');
    $('.column-2x').width((base_dim + gutter) * 2).height('100%');
    $('.square').width(base_dim).height(base_dim);
    $('.rectangle').width(base_dim).height(base_dim * 2 + gutter);
    $('.square-1x').width(base_dim).height(base_dim).css('margin_right', gutter);
    $('.square-2x').width(base_dim * 2 + gutter).height(base_dim * 2 + gutter);
    $('.rectangle-land').width(base_dim * 2 + gutter).height(base_dim);
    $('.rectangle-port').height(base_dim * 2 + gutter).width(base_dim).css('margin_right', gutter);
    $('.column, .column-2x').children().css('margin_bottom', gutter);
    return $('.column, .column-2x').children('*:last-child').css('margin_bottom', 0);
  };

  DrawElements = function(data, status, xhr) {
    if (status = "success") {
      return $.each(data, function(room_name, room_data) {
        return $.each(room_data["elements"], function(element_name, element_data) {
          var element;
          element = $("#" + room_name + " #" + element_name + " div");
          element.removeClass();
          return element.addClass("" + element_data["state"]);
        });
      });
    }
  };

  $(".screen").each(function() {
    return $.getJSON("" + ($(this).attr("id")) + "/state", DrawElements);
  });

  $(document).on("click", "[data-command]", function() {
    var request;
    request = "/" + ($(this).closest('.screen').attr('id'));
    if ($(this).attr("id")) {
      request += "/" + ($(this).attr('id'));
    }
    request += "/" + ($(this).data('command'));
    return $.getJSON(request, DrawElements);
  });

  DrawBlocks();

  window.onresize = DrawBlocks;

}).call(this);
