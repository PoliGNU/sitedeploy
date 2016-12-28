# encoding: UTF-8
# -*- mode: ruby -*-
# vi: set ft=ruby :

#
# Available Rake tasks:
# $ rake -T
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
  # @param config [Hash] configuration values for the `Kitchen::Config` class.
  # @return [Collection<Instance>] all instances.
  def kitchen_instances(config)
    Kitchen::Config.new(config).instances
  end

  # Runs a test kitchen action against some instances.
  #
  # @param action [String] kitchen action to run (defaults to `'test'`).
  # @param loader_config [Hash] loader configuration options.
  # @return void
  def run_kitchen(action, loader_config = {})
    action = 'test' if action.nil?
    require 'kitchen'
    Kitchen.logger = Kitchen.default_file_logger
    config = { loader: Kitchen::Loader::YAML.new(loader_config) }
    kitchen_instances(config).each { |i| i.send(action) }
  end

  desc 'Run Kitchen integration tests using vagrant'
  task :vagrant, [:action] do |_t, args|
    run_kitchen(args.action)
  end

  desc 'Run Kitchen integration tests using docker'
  task :docker, [:action] do |_t, args|
    run_kitchen(args.action, local_config: '.kitchen.docker.yml')
  end
end

desc 'Run Kitchen integration tests (Vagrant on local machine and Docker on CI Server)'
task :integration, [:action] =>
  ci? ? %w(integration:docker) : %w(integration:vagrant)

desc 'Run style and integration tests'
task default: %w(style integration)

desc 'Run smoke tests with Bats'
task :smoke do 
  run_kitchen('converge')
  if system "bats test/smoke"
    run_kitchen('destroy')
  else
    return $?.exitstatus	  
  end
end

