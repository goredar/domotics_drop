(function() {
  var DrawBlocks, PutElements;

  DrawBlocks = function() {
    var base_dim, col_count, gutter, row_count, w_height, w_width;
    w_width = $(window).width();
    w_height = $(window).height();
    gutter = Math.round(w_height / 80);
    row_count = 4;
    base_dim = Math.round((w_height - row_count * gutter) / row_count);
    col_count = 6;
    $('html').width(w_width).height(w_height);
    $('body').width(w_width).height(w_height - gutter * 2);
    $('body').css('font-size', "" + (base_dim / 2) + "px");
    $('.column').width(base_dim + gutter).height('100%');
    $('.column-2x').width((base_dim + gutter) * 2).height('100%');
    $('.spacer').width(w_width - (base_dim + gutter) * col_count - gutter * 2).height('100%').css('margin_right', gutter).css('margin_left', gutter);
    $('.square').width(base_dim).height(base_dim);
    $('.rectangle').width(base_dim).height(base_dim * 2 + gutter);
    $('.square-1x').width(base_dim).height(base_dim).css('margin_right', gutter);
    $('.square-2x').width(base_dim * 2 + gutter).height(base_dim * 2 + gutter);
    $('.rectangle-land').width(base_dim * 2 + gutter).height(base_dim);
    $('.rectangle-port').height(base_dim * 2 + gutter).width(base_dim).css('margin_right', gutter);
    $('.column, .column-2x').children().css('margin_bottom', gutter);
    return $('.column, .column-2x').children('*:last-child').css('margin_bottom', 0);
  };

  PutElements = function(data, status, xhr) {
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
    return $.getJSON("" + ($(this).attr("id")) + "/state", PutElements);
  });

  $(document).on("click", "[data-command]", function() {
    var request;
    request = "/" + ($(this).closest('.screen').attr('id'));
    if ($(this).attr("id")) {
      request += "/" + ($(this).attr('id'));
    }
    request += "/" + ($(this).data('command'));
    return $.getJSON(request, PutElements);
  });

  DrawBlocks();

  window.onresize = DrawBlocks;

}).call(this);
