require 'publisher'

desc 'publishes static site to Github'
task :publish do
  Publisher.publish
end
