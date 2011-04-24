module OmniAuth
  module Strategies
    autoload :Yahoo, 'lib/oauth-strategies/yahoo'
  end
end

Rails.application.config.middleware.use OmniAuth::Builder do
require 'openid/store/filesystem'
  provider :twitter, 'y1ur5nbJre7OKYBj6qu39g', 'erWPi7Nn8scCBs9wuHSi2eswcI7F287pVTCVQ4sr5Y'
  provider :facebook, '173244139356614', '0c0a2d4ce4996bcd4a3e7800ce8b50f8', :scope => 'email,offline_access,publish_stream,user_likes,user_online_presence,friends_online_presence,read_stream,email,user_photos,user_about_me,user_birthday,user_interests,read_mailbox,read_requests'
	provider :openid, nil, :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'
	#provider :yahoo, 'dj0yJmk9TmFvZlNHTHhZVDNFJmQ9WVdrOVJHZGFXVTlITm04bWNHbzlPRGN5TkRjd01qWXkmcz1jb25zdW1lcnNlY3JldCZ4PWQ4', '44b532c4f20b480bfbd7e624fc0788d5dbfcbbdb'

	use OmniAuth::Strategies::OpenID, OpenID::Store::Filesystem.new('~/.tmp'), :name => 'yahoo', :identifier => 'yahoo.com'
end

