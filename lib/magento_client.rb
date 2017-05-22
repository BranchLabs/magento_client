require 'oauth'
require 'httparty'
require 'http-cookie'
require 'nokogiri'
require 'multi_json'

require 'magento_client/version'
require 'magento_client/handshake'

class MagentoClient
  include Handshake

  def initialize(config = {})
    @config = OpenStruct.new(config)
  end

  def get(params)
    MultiJson.load(access_token.get(params).body)
  end

  def access_token
    return @access_token if @access_token

    code = get_verifier_code
    @access_token = request_token.get_access_token(:oauth_verifier => code)
  end

  def request_token
    @request_token ||= consumer.get_request_token
  end

  def consumer
    # Need to authorize directly with a specific store view for Magento sites with multiple
    # on one domain.
    store_code = "/#{@config.store_code}" unless @config.store_code.nil?

    @consumer ||= OAuth::Consumer.new(@config.key, @config.secret,
      :site => @config.url,
      :request_token_path => "#{store_code}/oauth/initiate",
      :authorize_path => "#{store_code}/admin/oauth_authorize",
      :access_token_path => "#{store_code}/oauth/token",
      :http_method => :get
    )
  end

  def reset
    @consumer = @request_token = nil
  end
end

