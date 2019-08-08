require 'publisher'

desc 'publishes static site to a remote Git repository'
task :publish do
  Publisher.publish
end
