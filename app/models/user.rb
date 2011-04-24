class User < ActiveRecord::Base

	attr_accessible :display_name, :avatar, :email, :background, :divs, :fonts
	has_many :authorizations, :dependent => :destroy
	has_many :posts, :dependent => :destroy
	has_many :relationships, :foreign_key => "follower_id", :dependent => :destroy
	has_many :following, :through => :relationships, :source => :followed
	has_many :reverse_relationships, :foreign_key => "followed_id", :class_name => "Relationship", :dependent => :destroy
	has_many :followers, :through => :reverse_relationships
	has_many :uploads, :dependent => :destroy
	has_attached_file :avatar, :styles => { :thumb => ["75x75>"], :display => ["250x250>"] }
	validates_uniqueness_of :display_name, :allow_nil => 'true'
	validates :display_name, :length => { :maximum => 35 }
	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, :format => { :with => email_regex },
										:uniqueness => { :case_sensitive => false },
										:allow_nil => 'true',
										:allow_blank => 'true'

#	def before_save
#    if self.display_name.nil? || self.display_name.blank?
#      self.display_name = "user#{Time.now.to_i}"
#    end		
#  end 
	def self.create_from_hash!(hash)
		if hash['credentials'].nil?
			create! do |user|
				user.name = hash['user_info']['name']
				user.email = hash['user_info']['email']
				user.provider = hash['provider']
				user.image = hash['user_info']['image']
			end
		else
			create! do |user|
				user.name = hash['user_info']['name']
				user.email = hash['user_info']['email']
				user.provider = hash['provider']
				user.image = hash['user_info']['image']
				user.secret = hash['credentials']['secret']
				user.token = hash['credentials']['token']
			end
		end
	end

	
	
	def feed
		Post.where("user_id = ?", id)
	end
	
	def status_feed
		Post.from_users_followed_by(self)
	end
	
	def following?(followed)
		relationships.find_by_followed_id(followed)
	end
	
	def follow!(followed)
		relationships.create!(:followed_id => followed.id)
	end
	
	def unfollow!(followed)
		relationships.find_by_followed_id(followed).destroy
	end
	
	def unread
		inbox.where("read_state =?", false)
	end
	
	def inbox
		Message.where("recipient = ?", id)
	end
	
	def current_avatar
		Upload.where("user_id = ?", id).find(:all, :conditions => "photo_file_name IS NOT NULL").last
	end
	
	end
