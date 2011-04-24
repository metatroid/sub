class Authorization < ActiveRecord::Base
	belongs_to :user
	validates_presence_of :user_id, :uid, :provider
	validates_uniqueness_of :uid, :scope => :provider
	
	def self.find_from_hash(hash)
		find_by_provider_and_uid(hash['provider'], hash['uid'])
	end

	def self.create_from_hash(hash, user = nil)
		user ||= User.create_from_hash!(hash)
		if hash['credentials'].nil?
			Authorization.create(
				:user => user, 
				:uid => hash['uid'], 
				:provider => hash['provider'], 
				:email => hash['user_info']['email']||='', 
				:image => hash['user_info']['image']||='',
				:name => hash['user_info']['name']||=''
			)
		else
			Authorization.create(
				:user => user, 
				:uid => hash['uid'], 
				:provider => hash['provider'], 
				:email => hash['user_info']['email']||='', 
				:image => hash['user_info']['image']||='', 
				:secret => hash['credentials']['secret']||='', 
				:token => hash['credentials']['token']||='',
				:nickname => hash['user_info']['nickname']||='',
				:name => hash['user_info']['name']||=''
			)
		end

	end

end