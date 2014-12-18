$:.unshift File.expand_path("../../lib", __FILE__)
require 'bundler'
Bundler.require :default, :test
require 'sinatra/base'
require_relative '../lib/app.rb'
require 'minitest/autorun'
require 'rack/test'
require 'nokogiri'
require 'yaml/store'

class IdeaBoxAppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    IdeaBoxApp.new
  end

  def setup
    store = YAML::Store.new('db/test')
    store.transaction do
      store['ideas'] = []
    end
    IdeaStore.set_database(store)
  end

  def test_get_works
    get '/'
    assert last_response.ok?
    assert_equal 200, last_response.status
  end

  def test_get_can_take_search_phrase
    IdeaStore.create({"title" => "diet", "description" => "pizza all the time"})
    get '/?search_phrase=pizza'
    assert last_response.ok?
    html = Nokogiri::HTML(last_response.body)
    assert_equal "pizza all the time", html.css('.description').text.strip
  end

end
