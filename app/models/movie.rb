class Movie < ActiveRecord::Base
	def self.AllRatings
		self.select(:rating).map(&:rating).uniq
	end
end
