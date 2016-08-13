
# Import other external rake tasks
Dir.glob('tasks/*.rake').each { |r| import r }

# Import dependencies
require 'stove/rake_task'
require 'cookstyle'
require 'rubocop/rake_task'
require 'foodcritic'
require 'rspec/core/rake_task'

# Publish This cookbook
Stove::RakeTask.new

# Style tests. Rubocop and Foodcritic
namespace :style do
  desc 'Run Ruby style checks'
  RuboCop::RakeTask.new(:ruby)

  desc 'Run Chef style checks'
  FoodCritic::Rake::LintTask.new(:chef) do |t|
    t.options = {
      fail_tags: ['any']
    }
  end
end

# Style tests. Rubocop and Foodcritic
namespace :test do
  desc 'Run rspec'
  RSpec::Core::RakeTask.new(:unit)
end

desc 'Run all style checks'
task style: ['style:chef', 'style:ruby']

desc 'Run all test'
task test: ['test:unit']

desc 'Run all tests on Travis'
task travis: ['style', 'test']

# Default
task default: :travis
