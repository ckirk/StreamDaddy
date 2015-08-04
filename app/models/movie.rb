class Movie < ActiveRecord::Base
	has_one :netflix_movie

	# NEXT STEPS
		# Import movie lists for Netflix and HBO Go to db
		# Create ratings model
		# Look up all ratings for each movie, save to db

	# def get_imdb_score
	# 	aggregator = WorthWatching::Aggregator.new(ENV["rt_api_key"], ENV["tmdb_api_key"])
	# end

	def get_info
		self.get_tmdb_id
		self.get_imdb_id
		self.get_imdb_score
	end

	# uses title and release year to find movie on tmdb
	def get_tmdb_id
		# Search Params
		title = self.title
		release_year = self.release_year

		api_key = ENV["tmdb_api_key"]
		query = CGI.escape(title)
		year = release_year
		max_pages = 1

		response = HTTParty.get("http://api.themoviedb.org/3/search/movie?api_key=#{api_key}&page=#{max_pages}&query=#{query}&primary_release_year=#{year}")
		self.tmdb_id = response['results'][0]['id']
		if self.save
			logger.info "tmdb_id: #{self.tmdb_id}"
		else
			logger.info "ERROR!"
		end
	end

	# uses tmdb_id to get imdb_id (other metadata available)
	def get_imdb_id
		if self.tmdb_id.nil?
			logger.info "ERROR: No tmdb_id found"
		else
			# Search Params
			id = self.tmdb_id
			api_key = ENV["tmdb_api_key"]

			response = HTTParty.get("http://api.themoviedb.org/3/movie/#{id}?api_key=#{api_key}")
			self.imdb_id = response['imdb_id']
			logger.info "imdb_id: #{self.imdb_id}" if self.save
		end
	end

	# uses imdb_id to get imdb score
	def get_imdb_score
		if self.imdb_id.nil?
			logger.info "ERROR: No imdb_id found"
		else
			id = self.imdb_id
			movie = Imdb::Movie.new("#{id[2..-1]}")
			self.imdb_score = movie.rating
			logger.info "IMDB Score: #{movie.rating}" if self.save
		end
	end

	def get_metascore

	end

	def self.import(start_page = 1, total_pages = 1)
		Rails.logger.level = 1
		stop_page = start_page + total_pages - 1
		@imported = 0
		@skipped = 0

		# Search Params
		content_type = "content_type=1"
		sort = "sort=available_from desc"
		view = "view=synopsis"

		user = "8ef67b8a-116a-4c74-9dc8-8ea25812e8a3"
		api_key = "8ef67b8a116a4c749dc88ea25812e8a300a3cd5adc1ad5e037db4e05ddb64d8459a5fbe3e4dbb4f019289026606b5036f88372cfd840d269296d08b44e85fb3747a99697b100c6d9a8d62ef0452d4aa7"

		(start_page..stop_page).each do |page|
			logger.info "--------------------------"
			logger.info "Requesting Page #{page}..."
			logger.info "--------------------------"

		  url = CGI.escape("http://instantwatcher.com/search?page=#{page}&#{content_type}&#{sort}&#{view}")
		  response = HTTParty.get("https://api.import.io/store/data/800dd083-18a5-4b58-99b2-98dd7f844a27/_query?input/webpage/url=#{url}&_user=#{user}&_apikey=#{api_key}")

		  @results = response['results']

		  @results.each do |result|
		    netflix_id = result['netflix_page'].match(/netflix.com\/title\/([0-9]+)/).captures[0]
		    if NetflixMovie.find_by_provider_id(netflix_id).nil?
		      movie = Movie.create(
		        title: result['title'],
		        poster_url: result['thumbnail'],
		        synopsis: result['synopsis'],
		        director: result['director'],
		        release_year: Time.at(result['year/_source'].to_f),
		        runtime: result['runtime'],
		        content_rating: result['rating'],
		        netflix_score: result['netflix_rating'],
		        rt_score: result['rt_meter'],
		        rt_audience: result['rt_audience']
		      )
		      if movie.save
		        logger.info "Movie Created -- #{result['title']}"
		        @imported += 1
		      end
		      NetflixMovie.create(
		        movie_id: movie.id,
		        available: true,
		        available_since: DateTime.strptime(result['available_since'], "%b %d '%y"),
		        page_link: result['netflix_page'],
		        play_link: result['play_link'],
		        stream_quality: result['stream_quality'],
		        provider_id: netflix_id
		      )
		      # @imported_movies.push(result['title'])
		      # @netflix_movie_created += 1
		    else
		      @skipped += 1
		      logger.info "** Movie Skipped (#{@skipped}) -- #{result['title']}"
		    end
		  end

		end
		logger.info "---------------"
		logger.info "IMPORT COMPLETE"
		logger.info "---------------"
		logger.info "Scanned pages #{start_page}-#{stop_page} (#{stop_page-start_page+1} Pages Total)"
		logger.info "Imported #{@imported} Moives"
		logger.info "Skipped #{@skipped} Moives"
	end
		 
end
