class Message < ActiveRecord::Base
	validates :content, :presence => true
	validates :subject, :presence => true
	validates :sender, :presence => true
	validates :recipient, :presence => true
	attr_accessible :content, :subject, :recipient
	default_scope :order => 'messages.created_at DESC'
end
