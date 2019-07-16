puts "LOAD_PATH = #{$LOAD_PATH}"

require 'publisher'

desc 'publishes static site to Github'
task :publish do
  Publisher.publish
end
