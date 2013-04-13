module RoomsHelper
  def lights_action(room, action, progress)
    link_to({ controller: :rooms, action: :command, id: room.id, options: action },
    {remote: true, class: 'button tiny' }) do
      content_tag(:i, class: 'icon-2x ' + case action
      when :lights_off
        'icon-power'
      when :lights_min
        'icon-brightness'
      when :lights_mid
        'icon-brightnesshalf'
      when :lights_max
        'icon-brightnessfull'
      when :process
        'icon-uptime icon-spin'
      end + ((' icon-spin' if progress)||'')) {}
    end
  end
end