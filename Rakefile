require 'rake/testtask'

task :default => [:test]

Rake::TestTask.new do |t|
  t.libs << 'test'
end

desc "Run tests"
task :default => :test

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
      Slim::Template.new(file).render
    end
  end
  File.open("web/index.html", 'w') do |f|
    f.write Slim::Template.new('web/index.html.slim').render
  end
end

desc 'Compile web-based user interface'
task :web => ['web/css/style.css', 'web/js/script.js', 'web/index.html'] do
  $stdout.puts 'compiling done!'
  %x[sudo cp -R ./web/* /srv/http ]
end

desc 'Run app'
task :run do
  ruby "./app.rb"
end

desc 'Pull'
task :pull do
  puts %x{ sudo git stash }
  puts %x{ sudo git pull }
  puts %x{ sudo bundle update }
  puts %x{ sudo systemctl restart domotics.service }
end

desc 'Push'
task :push, :commit_message do |t, args|
  %x(git add --all .)
  if args[:commit_message]
    %x(git commit -a -m "#{args[:commit_message]}")
  else 
    %x(git commit -a --reuse-message=HEAD)
  end
  %x(git push)
end
