(function() {
  var DrawBlocks, PullElements, base_dim, col_count, gutter, gutter_part, row_count;

  row_count = 4;

  col_count = 6;

  gutter_part = 0.04;

  base_dim = 0;

  gutter = 0;

  DrawBlocks = function() {
    var container_width, w_height, w_width;
    w_width = $(window).width();
    w_height = $(window).height();
    base_dim = Math.round(w_height / row_count / (1 + gutter_part));
    gutter = Math.round(base_dim * gutter_part);
    $('body').height(w_height - gutter * 2);
    $('body').css('font-size', "" + (base_dim / 2) + "px");
    container_width = (base_dim + gutter) * col_count;
    $('.container').width(container_width);
    $('.spacer').width(w_width - container_width - gutter * 2).css('margin_right', gutter).css('margin_left', gutter);
    $('.column').width(base_dim + gutter);
    $('.column-2x').width((base_dim + gutter) * 2);
    $('.square').width(base_dim).height(base_dim);
    $('.rectangle').width(base_dim).height(base_dim * 2 + gutter);
    $('.square-1x').width(base_dim).height(base_dim).css('margin_right', gutter);
    $('.square-2x').width(base_dim * 2 + gutter).height(base_dim * 2 + gutter);
    $('.rectangle-land').width(base_dim * 2 + gutter).height(base_dim);
    $('.rectangle-port').height(base_dim * 2 + gutter).width(base_dim).css('margin_right', gutter);
    return $('.column, .column-2x').children().css('margin_bottom', gutter);
  };

  PullElements = function(data, status, xhr) {
    if (status === "success") {
      return $.each(data, function(room_name, room_data) {
        return $.each(room_data["elements"], function(element_name, element_data) {
          var element;
          element = $("#" + room_name + " #" + element_name + " div");
          element.removeClass();
          element.addClass(element_data["state"]);
          if (element_data["info"]) {
            element = $("#" + room_name + " #" + element_name + " .info");
            if (element.size() !== 0) {
              return element.html(element_data["info"]);
            } else {
              return $("#" + room_name + " #" + element_name).append("<span class='info'>" + element_data['info'] + "</span>");
            }
          }
        });
      });
    }
  };

  $(".screen").each(function() {
    return $.getJSON("" + ($(this).attr("id")) + "/state", PullElements);
  });

  $(document).on("click", "[data-command]", function() {
    var request, screen;
    screen = $(this).closest('.screen');
    if (screen.size() === 1) {
      request = "/" + ($(this).closest('.screen').attr('id'));
    } else {
      request = "";
    }
    if ($(this).attr("id")) {
      request += "/" + ($(this).attr('id'));
    }
    request += "/" + ($(this).data('command'));
    $.getJSON(request, PullElements);
    return false;
  });

  $(document).on("click", ".spacer", function() {
    $(".screen").each(function() {
      var next_screen;
      if ($(this).is(":visible")) {
        $(this).hide();
        next_screen = $(this).next(".screen");
        if (next_screen.size() === 1) {
          next_screen.show();
        } else {
          $(".screen").first().show();
        }
        return false;
      }
      return true;
    });
    return false;
  });

  $(document).on("click", "[data-dialog]", function() {
    var dialog, quit_button;
    $(".screen").hide();
    dialog = $("#" + ($(this).attr('id')) + "_dialog");
    dialog.show();
    quit_button = dialog.children(".quit");
    quit_button.data("return", $(this).closest('.screen'));
    $(document).on("click", quit_button, function() {
      $(this).closest('.dialog').hide();
      return $(this).data("return").show();
    });
    return dialog.children(".square").css('margin_bottom', gutter).css('margin_right', gutter);
  });

  $(".screen:not(:first-child)").hide();

  DrawBlocks();

  window.onresize = DrawBlocks;

}).call(this);
