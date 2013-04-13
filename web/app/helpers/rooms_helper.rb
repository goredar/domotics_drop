module RoomsHelper
  def lights_action(room, action)
    link_to({ controller: :rooms, action: :command, id: room.id, options: action },
    {remote: true, class: 'button tiny' }) do
      if params[:options] == action
        content_tag(:i, class: 'icon-2x icon-spinner icon-spin')
      else
        content_tag(:i, class: 'icon-2x ' + case action
        when :lights_off
          'icon-power'
        when :lights_min
          'icon-brightness'
        when :lights_mid
          'icon-brightnesshalf'
        when :lights_max
          'icon-brightnessfull'
        end) {}
      end
    end.html_safe
  end
end