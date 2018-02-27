require 'simplecov'
require_relative '../random_search/random_search'

SimpleCov.start "rails" do
  add_filter [/benchmarks.rb/]
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.profile_examples = 10
  config.fail_fast = true
end
