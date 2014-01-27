require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.test_files = FileList['test/**/*_spec.rb']
  t.verbose = true
end

if system('vagrant --version > /dev/null 2>&1') && system('vagrant exec -h > /dev/null 2>&1')
  desc 'Run tests within Vagrant'
  task :vagrant_test do
    system 'vagrant exec rake test'
  end

  task :default => :vagrant_test
else
  task :default => :test
end
