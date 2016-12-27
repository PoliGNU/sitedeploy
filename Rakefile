# encoding: UTF-8
# -*- mode: ruby -*-
# vi: set ft=ruby :

#
# Available Rake tasks:
#
# $ rake -T
# rake clean                    # Clean some generated files
# rake default                  # Run style and integration tests
# rake integration[regexp,action]          # Run Kitchen integration tests using Vagrant on local machine and Docker on CI Server
# rake style                    # Run all style checks
# rake style:chef               # Run Chef style checks using foodcritic
# rake style:ruby               # Run Ruby style checks using rubocop
# rake style:ruby:auto_correct  # Auto-correct RuboCop offenses
#
# More info at https://github.com/ruby/rake/blob/master/doc/rakefile.rdoc
#

require 'bundler/setup'

# Checks if we are inside a Continuous Integration machine.
#
# @return [Boolean] whether we are inside a CI.
# @example
#   ci? #=> false
def ci?
  ENV['CI'] == 'true'
end

desc 'Clean some generated files'
task :clean do
  %w(
    Berksfile.lock
    .bundle
    .cache
    coverage
    Gemfile.lock
    .kitchen
    metadata.json
    vendor
  ).each { |f| FileUtils.rm_rf(Dir.glob(f)) }
end

namespace :style do
  require 'rubocop/rake_task'
  desc 'Run Ruby style checks using rubocop'
  RuboCop::RakeTask.new(:ruby)

  require 'foodcritic'
  desc 'Run Chef style checks using foodcritic'
  FoodCritic::Rake::LintTask.new(:chef)
end

desc 'Run all style checks'
task style: %w(style:chef style:ruby)

desc 'Run Kitchen integration tests'
namespace :integration do
  # Gets a collection of instances.
  #
  # @param regexp [String] regular expression to match against instance names.
  # @param config [Hash] configuration values for the `Kitchen::Config` class.
  # @return [Collection<Instance>] all instances.
  def kitchen_instances(regexp, config)
    instances = Kitchen::Config.new(config).instances
    return instances if regexp.nil? || regexp == 'all'
    instances.get_all(Regexp.new(regexp))
  end

  # Runs a test kitchen action against some instances.
  #
  # @param action [String] kitchen action to run (defaults to `'test'`).
  # @param regexp [String] regular expression to match against instance names.
  # @param loader_config [Hash] loader configuration options.
  # @return void
  def run_kitchen(action, regexp, loader_config = {})
    action = 'test' if action.nil?
    require 'kitchen'
    Kitchen.logger = Kitchen.default_file_logger
    config = { loader: Kitchen::Loader::YAML.new(loader_config) }
    kitchen_instances(regexp, config).each { |i| i.send(action) }
  end

  desc 'Run Kitchen integration tests using vagrant'
  task :vagrant, [:regexp, :action] do |_t, args|
    run_kitchen(args.action, args.regexp)
  end

  desc 'Run Kitchen integration tests using docker'
  task :docker, [:regexp, :action] do |_t, args|
    run_kitchen(args.action, args.regexp, local_config: '.kitchen.docker.yml')
  end
end

desc 'Run Kitchen integration tests (Vagrant on local machine and Docker on CI Server)'
task :integration, [:regexp, :action] =>
  ci? ? %w(integration:docker) : %w(integration:vagrant)

desc 'Run style and integration tests'
task default: %w(style integration)
