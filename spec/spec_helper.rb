# frozen_string_literal: true
$LOAD_PATH.unshift File.dirname('./libraries')

require 'webmock/rspec'
require 'simplecov'
require 'codecov'

SimpleCov.start do
  add_filter '/spec/' # Ignore all testing files
end
SimpleCov.formatter = SimpleCov::Formatter::Codecov if ENV['CI'] == 'true'
