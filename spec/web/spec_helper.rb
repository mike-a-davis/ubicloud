# frozen_string_literal: true

require_relative "../spec_helper"
raise "test database doesn't end with test" if DB.opts[:database] && !DB.opts[:database].end_with?("test")

require "capybara"
require "capybara/rspec"
require "rack/test"

Gem.suffix_pattern

Clover.plugin :not_found do
  raise "404 - File Not Found"
end
Clover.plugin :error_handler do |e|
  raise e
end

Capybara.app = Clover.freeze.app
Capybara.exact = true

module RackTestPlus
  include Rack::Test::Methods

  def app
    Capybara.app
  end
end

RSpec.configure do |config|
  config.include RackTestPlus
  config.include Capybara::DSL
  config.after do
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end
