# frozen_string_literal: true
$LOAD_PATH.unshift File.dirname('./libraries')

require 'webmock/rspec'
require 'simplecov'
require 'codecov'

SimpleCov.start
SimpleCov.formatter = SimpleCov::Formatter::Codecov if ENV['CI'] == 'true'
