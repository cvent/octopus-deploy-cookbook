# frozen_string_literal: true
begin
  require 'chef/cookbook/metadata'
  require 'github_changelog_generator/task'

  metadata = Chef::Cookbook::Metadata.new
  metadata.from_file('metadata.rb')

  GitHubChangelogGenerator::RakeTask.new :changelog do |config|
    config.user = 'cvent'
    config.project = 'octopus-deploy-cookbook'
    config.since_tag = 'v0.5.0'
    config.future_release = "v#{metadata.version}"
    config.issues = false
    config.add_pr_wo_labels = false
    config.enhancement_labels = %w(enhancement)
    config.bug_labels = %w(bug)
    config.exclude_labels = %w(cleanup duplicate question wontfix no_changelog)
  end
rescue LoadError
  puts 'Problem loading gems please install chef and github_changelog_generator'
end
