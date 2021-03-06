require 'omniauth/oauth'
require 'multi_json'

module OmniAuth
  module Strategies
    #
    # Authenticate to Google via OAuth and retrieve basic
    # user information.
    #
    # Usage:
    #
    # use OmniAuth::Strategies::Google, 'consumerkey', 'consumersecret'
    #
    class Google < OmniAuth::Strategies::OAuth
      def initialize(app, consumer_key, consumer_secret)
        # consistently fails if the entire url is not given.
        super(app, :google, consumer_key, consumer_secret,
          :request_token_url => 'https://www.google.com/accounts/OAuthGetRequestToken',
          :access_token_url => 'https://www.google.com/accounts/OAuthGetAccessToken',
          :authorize_url => "https://www.google.com/accounts/OAuthAuthorizeToken"
          )
      end
      
      def auth_hash
        ui = user_info
        OmniAuth::Utils.deep_merge(super, {
          'uid' => ui['uid'],
          'user_info' => ui,
          'extra' => {'user_hash' => user_hash}
        })
      end
      
      def user_info
        email = user_hash['feed']['id']['$t']
        
        name = user_hash['feed']['author'].first['name']['$t']
        name = email if name.strip == '(unknown)'
        
        {
          'email' => email,
          'uid' => email,
          'name' => name
        }
      end
      
      def user_hash
        # Google is very strict about keeping authorization and authentication apart. They provide user info for OpenID logins, but not OAuth.
        # They give no endpoint to get a user's profile directly that I can find. We *can* get their name and email out of the contacts feed, however.
        # It will fail, however, in the extremely rare case of a user who has a Google Account but has never even signed up for Gmail.
        @user_hash ||= MultiJson.decode(@access_token.get("http://www.google.com/m8/feeds/contacts/default/full?max-results=1&alt=json").body)
      end

      # Monkeypatch OmniAuth to pass the scope in the consumer.get_request_token call
      def request_phase
        request_token = consumer.get_request_token({:oauth_callback => callback_url}, {:scope => "http://www.google.com/m8/feeds"})
        (session[:oauth]||={})[name.to_sym] = {:callback_confirmed => request_token.callback_confirmed?, :request_token => request_token.token, :request_secret => request_token.secret}
        r = Rack::Response.new
        r.redirect request_token.authorize_url
        r.finish
      end

    end
  end
end