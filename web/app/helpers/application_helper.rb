module ApplicationHelper
  def link_to_menu(label, path, icon=nil, deep = 1)
    content_tag :li, :class => ('active' if '/' + request.path_info.split('/')[1,deep].join('/') == path) do
      content_tag :a, :href => path do
        res = ''
        if icon
          icon, enclosed = icon.split
          res += content_tag(:i, :class => "general#{'-enclosed' if enclosed} foundicon-#{icon}") {}
        end
        res += ' '+label
        res.html_safe
      end
    end
  end
end