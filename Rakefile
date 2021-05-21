# frozen_string_literal: true

require "bundler/gem_tasks"
require "standard/rake"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec).pattern = "spec/unit/**{,/*/**}/*_spec.rb"
RSpec::Core::RakeTask.new(:integration).pattern = "spec/integration/**{,/*/**}/*_spec.rb"

task default: %i[standard spec]
