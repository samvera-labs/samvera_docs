# Add 'lib' directory to load path so rake tasks can require libs from there.
$LOAD_PATH << File.expand_path('lib', File.dirname(__FILE__))

# Load all .rake files under /tasks directory.
Dir.glob('tasks/**/*.rake').each { |file| load file }
