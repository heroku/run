$:.unshift(File.expand_path(File.join(File.dirname(File.dirname($0)), "lib")))

require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/*_test.rb']
end

task default: :test

