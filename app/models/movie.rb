class Movie < ActiveRecord::Base
	has_one :netflix_movie

	# NEXT STEPS
		# Import movie lists for Netflix and HBO Go to db
		# Create ratings model
		# Look up all ratings for each movie, save to db
		 
end
