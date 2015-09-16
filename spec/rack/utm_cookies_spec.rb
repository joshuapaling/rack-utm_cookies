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

  def cookies
    rack_mock_session.cookie_jar.instance_variable_get(:@cookies)
  end

  it 'has a version number' do
    expect(Rack::UtmCookies::VERSION).not_to be nil
  end

  it 'tacks on UTM cookies before passing response down the middleware stack' do
    get('/?utm_source=the_source&utm_medium=the_medium&utm_campaign=the_campaign')
    # we DON'T want to just check cookies from the response like other methods - we
    # explicitly want the cookies in the request that gets passed on to our NESTED
    # rack app
    req = Rack::Request.new(nested_rack_app.env)
    expect(req.cookies['utm_source']).to eq('the_source')
    expect(req.cookies['utm_medium']).to eq('the_medium')
    expect(req.cookies['utm_campaign']).to eq('the_campaign')
  end

  it "does nothing if the minimum required params of utm_source, utm_medium and utm_campaign aren't present" do
    get('/?utm_source=the_source&utm_campaign=the_campaign')
    expect(cookies.count).to eq(0)
  end

  it 'sets cookies for the current subdomain in the response' do
    get('/?utm_source=the_source&utm_medium=the_medium&utm_campaign=the_campaign')
    expect(rack_mock_session.cookie_jar["utm_source"]).to eq('the_source')
    expect(rack_mock_session.cookie_jar["utm_medium"]).to eq('the_medium')
    expect(rack_mock_session.cookie_jar["utm_campaign"]).to eq('the_campaign')

    cookies.each do |c|
      expect(c.domain).to eq('www.example.com')
    end
  end

  context 'with domain option' do
    let(:app) { Rack::UtmCookies.new(nested_rack_app, {
        domain: '.example.com'
      }) }

    it 'sets cookies to the domain passed in' do
      get('/?utm_source=the_source&utm_medium=the_medium&utm_campaign=the_campaign')
      expect(cookies.count).to eq(3)
      cookies.each do |c|
        expect(c.domain).to eq('.example.com')
      end
    end
  end
end
