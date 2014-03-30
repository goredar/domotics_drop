(function() {
  var rooms, view;

  view = {
    row_count: 4,
    col_count: 6,
    gutter_part: 0.04,
    init: function() {
      $(".screen:not(:first-child)").hide();
      window.onresize = function() {
        return view.resize.call(view);
      };
      this.resize();
      return this.hook();
    },
    resize: function() {
      var base_dim, container_width, gutter, w_height, w_width;
      w_width = $(window).width();
      w_height = $(window).height();
      base_dim = Math.round(w_height / (this.row_count + this.gutter_part * (this.row_count + 1)));
      gutter = Math.round(base_dim * this.gutter_part);
      container_width = (base_dim + gutter) * this.col_count;
      $('body').height(w_height - gutter * 2).css('font-size', "" + (base_dim / 2) + "px");
      $('.container').width(container_width);
      $('.spacer').width(w_width - container_width - gutter * 2).css('margin_right', gutter).css('margin_left', gutter);
      $('.column').width(base_dim + gutter);
      $('.column-2x').width((base_dim + gutter) * 2);
      $('.square').width(base_dim).height(base_dim).css('margin_right', gutter);
      $('.rectangle').width(base_dim).height(base_dim * 2 + gutter);
      $('.square-1x').width(base_dim).height(base_dim).css('margin_right', gutter);
      $('.square-2x').width(base_dim * 2 + gutter).height(base_dim * 2 + gutter);
      $('.rectangle-land').width(base_dim * 2 + gutter).height(base_dim);
      $('.rectangle-port').height(base_dim * 2 + gutter).width(base_dim).css('margin_right', gutter);
      $('.cam_shot').width(base_dim * 5 + gutter * 4);
      return $("[class*=square], [class*=rectangle]").css('margin_bottom', gutter);
    },
    rotate: function(direction) {
      return $(".screen").each(function() {
        var next_screen;
        if ($(this).is(":visible")) {
          $(this).hide();
          if (direction) {
            next_screen = $(this).next(".screen");
          } else {
            next_screen = $(this).prev(".screen");
          }
          if (next_screen.size() === 1) {
            next_screen.show();
          } else {
            if (direction) {
              $(".screen").first().show();
            } else {
              $(".screen").last().show();
            }
          }
          return false;
        }
        return true;
      });
    },
    hook: function() {
      var hook_action, spacer;
      if (!!$.os.phone || !!$.os.tablet) {
        hook_action = "tap";
      } else {
        hook_action = "click";
      }
      $(document).on(hook_action, "[data-command]", function() {
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
        request += "/" + ($(this).data('command')) + ".json";
        $.getJSON(request, rooms.update);
        return false;
      });
      spacer = $(".spacer .room_switch");
      $(document).on(hook_action, spacer.first(), function() {
        view.rotate(true);
        return false;
      });
      $(document).on(hook_action, spacer.last(), function() {
        view.rotate(false);
        return false;
      });
      return $(document).on(hook_action, "[data-screen]", function() {
        $(this).closest('.screen, .dialog').hide();
        $("#" + ($(this).data('screen'))).show();
        return false;
      });
    }
  };

  rooms = {
    init: function() {
      return $(".screen").each(function() {
        return $.getJSON("" + ($(this).attr("id")) + "/state.json", rooms.update);
      });
    },
    update: function(data, status, xhr) {
      var element, element_data, element_img, element_info, element_name, room_data, room_name, _results;
      if (status === "success") {
        _results = [];
        for (room_name in data) {
          room_data = data[room_name];
          _results.push((function() {
            var _ref, _results1;
            _ref = room_data.elements;
            _results1 = [];
            for (element_name in _ref) {
              element_data = _ref[element_name];
              element = $("#" + room_name + " #" + element_name + " div");
              element.removeClass();
              element.addClass(element_data.state);
              if (element_data.info) {
                element_info = element.children(".info");
                if (element_info.size() !== 0) {
                  element_info.html(element_data.info);
                } else {
                  element.append("<span class='info'>" + element_data.info + "</span>");
                }
              }
              if (element_data.img) {
                element_img = element.children("img");
                if (element_img.size() !== 0) {
                  _results1.push(element_img.attr('src', element_data.img));
                } else {
                  _results1.push(element.append("<img width=100% src=" + element_data.img + "></img>"));
                }
              } else {
                _results1.push(void 0);
              }
            }
            return _results1;
          })());
        }
        return _results;
      }
    }
  };

  $(function() {
    rooms.init();
    return view.init();
  });

}).call(this);
