class Question < ActiveRecord::Base
	attr_accessible :query
	has_one :answer
end
