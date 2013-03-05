ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  unless html_tag =~ /^<label/
    %{<div class="error">#{html_tag}<small>#{instance.error_message.first}</small></div>}.html_safe
  else
    %{<div class="error">#{html_tag}</div>}.html_safe
  end
end