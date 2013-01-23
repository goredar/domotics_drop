module ApplicationHelper
  def link_to_menu(label, path, deep = 1)
    content_tag :li, :class => ('active' if '/' + request.path_info.split('/')[1,deep].join('/') == path) do
      link_to label, path
    end
  end
end
