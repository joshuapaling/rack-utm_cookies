require 'spec_helper'
require 'rack/test'
# require 'rack/mock'
require 'byebug'
require 'awesome_print'

# idea from http://stackoverflow.com/questions/17506567/testing-middleware-with-rspec
class MockRackApp
  attr_reader :env

  def call(env)
    @env = env
    [200, {'Content-Type' => 'text/plain'}, ['OK']]
  end
end

module Rack
  module Test
    # otherwise it's example.org - and we want to be a bit more explicit
    # when testing cookies set for root vs sub domains
    DEFAULT_HOST = "www.example.com"
  end
end

describe Rack::UtmCookies do
  include Rack::Test::Methods

  let(:nested_rack_app) { MockRackApp.new }
  let(:app) { Rack::UtmCookies.new(nested_rack_app) }
  let(:request) { Rack::MockRequest.new(app) }

  it 'has a version number' do
    expect(Rack::UtmCookies::VERSION).not_to be nil
  end

  it 'tacks on UTM cookies before passing response down the middleware stack' do
    get('/?utm_source=the_source&utm_medium=the_medium')
    req = Rack::Request.new(nested_rack_app.env)
    expect(req.cookies['utm_source']).to eq('the_source')
    expect(req.cookies['utm_medium']).to eq('the_medium')
  end

  it 'sets cookies in the response' do
    get('/?utm_source=the_source&utm_medium=the_medium')
    expect(rack_mock_session.cookie_jar["utm_source"]).to eq('the_source')
    expect(rack_mock_session.cookie_jar["utm_medium"]).to eq('the_medium')

    the_cookies = rack_mock_session.cookie_jar.instance_variable_get(:@cookies)
    the_cookies.each do |c|
      expect(c.domain).to eq('www.example.com')
    end
  end

  context 'with domain option' do
    let(:app) { Rack::UtmCookies.new(nested_rack_app, {
        domain: '.example.com'
      }) }

    it 'respects domain option for cookies' do
      get('/?utm_source=the_source&utm_medium=the_medium')
      expect(rack_mock_session.cookie_jar["utm_source"]).to eq('the_source')
      expect(rack_mock_session.cookie_jar["utm_medium"]).to eq('the_medium')
      the_cookies = rack_mock_session.cookie_jar.instance_variable_get(:@cookies)
      the_cookies.each do |c|
        expect(c.domain).to eq('.example.com')
      end
    end
  end
end
