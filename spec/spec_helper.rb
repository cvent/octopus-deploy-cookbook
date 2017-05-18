# frozen_string_literal: true
$LOAD_PATH.unshift File.dirname('./libraries')

require 'simplecov'
SimpleCov.start

if ENV['CI'] == 'true'
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end
