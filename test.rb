class_map = Hash.new
[:device, :room, :element].each do |x|
  Dir["./app/#{x}/*.rb"].each do |file|
    #require file
    file =~ /\/(\w*)\.rb\Z/
    cn = $1.split(/_/)
    ind = (x == :device and cn[-1] == "board") ? cn[0].to_sym : cn.join('_').to_sym
    class_map[ind] = [x, cn.map{ |cn_p| cn_p.capitalize }.join]
  end
end
p class_map