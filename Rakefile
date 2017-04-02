# For CircleCI
require 'bundler/setup'

# Style tests. Rubocop
namespace :style do
  require 'rubocop/rake_task'
  desc 'RuboCop'
  RuboCop::RakeTask.new(:ruby)
end

desc 'CI Tasks'
task circleci: %w(style:ruby)

desc 'Default Tasks'
task default: %w(style:ruby)
