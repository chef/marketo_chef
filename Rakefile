# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

desc 'continuous integration tasks'
task ci: %i[test rubocop] do
end

task :rubocop do
  sh 'rubocop'
end

task default: :ci
