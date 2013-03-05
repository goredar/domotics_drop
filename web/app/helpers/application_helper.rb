module ApplicationHelper
  def link_to_menu(label, path, icon=nil, deep = 1)
    content_tag :li, :class => ('active' if '/' + request.path_info.split('/')[1,deep].join('/') == path) do
      link_to path do
        if icon
          selectors = icon.split.map { |sel| 'icon-'+sel }.join(' ')
          content_tag(:i, :class => selectors) {} + label
        else
          label
        end
      end
    end
  end
  def provide_title(title = nil)
    @title = title || t('.title')
    provide :title, @title
  end
end