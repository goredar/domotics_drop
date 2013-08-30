task :default => [:test]

desc 'Compile style sheets'
file 'web/css/style.css' => 'web/css/style.scss' do
  %x{ sass web/css/style.scss web/css/style.css }
end

desc 'Compile javascript'
file 'web/js/script.js' => 'web/js/script.js.coffee' do
  require 'coffee-script'
  File.open("web/js/script.js", 'w') do |f|
    f.write CoffeeScript.compile File.read("web/js/script.js.coffee")
  end
end

desc 'Compile HTML'
file 'web/index.html' => 'web/index.html.slim' do
  %x{ slimrb web/index.html.slim web/index.html }
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