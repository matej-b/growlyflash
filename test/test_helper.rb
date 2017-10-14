require 'bundler/setup'
require 'minitest/autorun'
require 'rails'
require 'growlyflash'
require 'action_controller'

# Ensure backward compatibility with Minitest 4
Minitest::Test = MiniTest::Unit::TestCase unless defined?(Minitest::Test)

ActiveSupport.test_order = :sorted

require "minitest/reporters"
Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new(:color => true)

module TestHelper
  Routes = ActionDispatch::Routing::RouteSet.new
  actions = %i(xhr_use_growlyflash xhr_skip_growlyflash)
  controller = "action_controller/growlyflash/integration_test/my"
  Routes.draw do
    actions.each do |action|
      get action, controller: controller
    end
  end

  ActionController::Base.send :include, Routes.url_helpers
end

ActionController::TestCase.class_eval do
  def setup
    @routes = TestHelper::Routes
  end
end
