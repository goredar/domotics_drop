task :default => [:test]

#desc 'Compile style sheets'
file 'web/css/style.css' => 'web/css/style.scss' do
  %x{ sass web/css/style.scss web/css/style.css }
end

#desc 'Compile javascript'
file 'web/js/script.js' => 'web/js/script.js.coffee' do
  require 'coffee-script'
  File.open("web/js/script.js", 'w') do |f|
    f.write CoffeeScript.compile File.read("web/js/script.js.coffee")
  end
end

#desc 'Compile HTML'
task 'web/index.html' do
  #%x{ slimrb web/index.html.slim web/index.html }
  require "slim"
  class Object
    def render(file)
      Slim::Template.new("web/views/#{file}.html.slim").render
    end
  end
  File.open("web/index.html", 'w') do |f|
    f.write Slim::Template.new('web/index.html.slim').render
  end
end

desc 'Compile web-based user interface'
task :web => ['web/css/style.css', 'web/js/script.js', 'web/index.html'] do
  $stdout.puts 'compiling... done!'
end

desc 'Make some tests'
task :test do
  ruby "./test/core_test.rb"
  ruby "./test/rack_test.rb"
end

desc 'Run app'
task :run do
  ruby "./app.rb"
end

desk 'Update'
task :up do
  %x{ sudo git pull }
  %x{ sudo systemctl restart domotics.service }
end