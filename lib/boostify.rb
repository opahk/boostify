begin
  require 'mongoid'
rescue LoadError
end
require 'money-rails'
require 'faraday'
require 'hmac_auth'
require 'boostify/engine' if defined?(Rails)

require 'boostify/models/donatable'
require 'boostify/models/active_record/charity'
require 'boostify/models/active_record/donation'
require 'boostify/models/mongoid/charity'
require 'boostify/models/mongoid/donation'
require 'boostify/jobs/sync_charities'

require 'haml'
if Rails::VERSION::MAJOR == 3
  require 'strong_parameters'
end

I18n.load_path += Dir[File.expand_path(File.join(File.dirname(__FILE__),
  '../locales', '*.yml')).to_s]

module Boostify
  mattr_accessor :api_endpoint
  self.api_endpoint = 'https://www.boost-project.com/network'

  # set partner id
  mattr_accessor :partner_id

  # set partner secret
  mattr_accessor :partner_secret

  mattr_accessor :orm
  @@orm = :mongoid

  mattr_accessor :donatable_class
  self.donatable_class = 'Transaction'

  mattr_accessor :favorite_charity_ids
  self.favorite_charity_ids = [1, 44]

  mattr_accessor :current_user_method
  self.current_user_method = 'current_user'

  mattr_accessor :current_user_class
  self.current_user_class = 'User'

  mattr_accessor :ssl_verify
  self.ssl_verify = true

  def self.config
    yield self
  end

  def self.donatable_class
    @@donatable_class.constantize
  end

  def self.current_user_class
    @@current_user_class.constantize
  end

  def self.charity_api_endpoint
    "#{Boostify.api_endpoint}/shops/#{partner_id_value}/charities"
  end

  def self.tracker_api_endpoint
    "#{Boostify.api_endpoint}/tracker/both.png"
  end

  def self.partner_id_value
    if Boostify.partner_id.respond_to? :call
      Boostify.partner_id.call
    else
      Boostify.partner_id
    end
  end

  CURRENCY = 'EUR'

  module Links
    FAQ = 'https://www.boost-project.com/de/faq'
    PRIVACY = 'https://www.boost-project.com/de/imprint'
    AGB = 'https://www.boost-project.com/de/agb'
    CHARITIES = 'https://www.boost-project.com/de/charities'
  end
end
