$:.unshift File.expand_path("../../lib", __FILE__)
require 'bundler'
Bundler.require :default, :test
require 'sinatra/base'
require_relative '../lib/app.rb'
require 'minitest/autorun'
require 'rack/test'
require 'nokogiri'

class IdeaBoxAppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    IdeaBoxApp.new
  end

  def test_get_works
    get '/'
    assert last_response.ok?
    assert_equal 200, last_response.status
  end

end
