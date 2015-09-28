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
		self.find_tmdb_entry
		self.get_imdb_id
		self.get_imdb_score
		self.get_metacritic_score
	end

	def get_imdbid
		if self.imdb_id.nil?
			movie = self.omdb_search(self.title, self.release_year)
			if movie[:title].nil?
				logger.info "No Movie Found"
			else
				self.imdb_id = movie[:imdb_id]
				if self.save
					logger.info "IMDB_id: #{movie[:imdb_id]}"
				else
					logger.info "failed to save"
				end
			end
		else
			logger.info "Already have IMDB_id"
		end

	end

	def self.collect_ratings(first = 1, total = 1)
		Rails.logger.level = 1
		last = first + total - 1
		(first..last).each do |id|
			logger.info "-----------------------------"
			logger.info "Getting ratings for Movie (#{id}) -- #{Movie.find(id).title}"
			Movie.find(id).get_info
		end
	end

	# Tries year before and after if release year doesnt return a tmdb_id
	def find_tmdb_entry
		if self.get_tmdb_id == false
			if self.get_tmdb_id(1) == false
				if self.get_tmdb_id(-1) == false
					logger.error "ERROR: Not able to find tmdb_id"
				else
					self.release_year -= 1
					self.save
				end
			else
				self.release_year += 1
				self.save
			end
		end
	end

	# uses title and release year to find movie on tmdb
	def get_tmdb_id(year_offset = 0)
		if self.tmdb_id.nil?
			# Search Params
			title = self.title
			release_year = self.release_year + year_offset

			api_key = ENV["tmdb_api_key"]
			query = CGI.escape(title)
			max_pages = 1

			response = HTTParty.get("http://api.themoviedb.org/3/search/movie?api_key=#{api_key}&page=#{max_pages}&query=#{query}&primary_release_year=#{release_year}")
			if response['total_results'] != 0
				id = response['results'][0]['id']
				self.tmdb_id = id
				if self.save
					logger.info "tmdb_id: #{id}"
				else
					logger.error "ERROR! Failed to save tmdb_id."
				end
			else
				logger.error "ERROR: No tmdb_id found."
				return false
			end
		else
			logger.info "Already have tmdb_id"
			return self.tmdb_id
		end
	end

	# uses tmdb_id to get imdb_id (other metadata available)
	def get_imdb_id
		if self.imdb_id.nil?
			if self.tmdb_id.nil?
				logger.error "ERROR: No tmdb_id found"
			else
				# Search Params
				id = self.tmdb_id
				api_key = ENV["tmdb_api_key"]

				response = HTTParty.get("http://api.themoviedb.org/3/movie/#{id}?api_key=#{api_key}")
				self.imdb_id = response['imdb_id']
				logger.info "imdb_id: #{self.imdb_id}" if self.save
			end
		else
			logger.info "Already have imdb_id"
			return self.imdb_id
		end
	end

	# uses imdb_id to get imdb score
	def get_imdb_score
		if self.imdb_score.nil?
			if self.imdb_id.nil?
				logger.info "ERROR: No imdb_id found"
			else
				id = self.imdb_id
				movie = Imdb::Movie.new("#{id[2..-1]}")
				score = movie.rating
				if !score.nil?
					self.imdb_score = score
					logger.info "IMDB Score: #{movie.rating}" if self.save
				else
					logger.error "ERROR: Failed to find IMDB score"
				end
			end
		else
			logger.info "Already have IMDB Score"
			return self.imdb_score
		end
	end

	# import.io metacritic api
	def get_metacritic_score
		if self.metacritic_score.nil?
			title = CGI.escape(self.title)
			year = self.release_year

			status_1 = CGI.escape("status[4]=1")
			status_2 = CGI.escape("status[3]=1")
			from = CGI.escape("date_range_from=01-01-#{year}")
			to = CGI.escape("date_range_to=01-01-#{year+1}")
			search_type = "search_type=advanced"

			metacritic_url = "http://www.metacritic.com/search/movie/#{title}/results?#{search_type}&#{status_1}&#{status_2}&#{from}&#{to}"
			# "http://www.metacritic.com/search/movie/the+matrix/results?status%5B4%5D=1&status%5B3%5D=1&date_range_from=01-01-1999&date_range_to=01-01-2000&search_type=advanced"

			api_key = "8ef67b8a116a4c749dc88ea25812e8a300a3cd5adc1ad5e037db4e05ddb64d8459a5fbe3e4dbb4f019289026606b5036f88372cfd840d269296d08b44e85fb3747a99697b100c6d9a8d62ef0452d4aa7"
			user = "8ef67b8a-116a-4c74-9dc8-8ea25812e8a3"
			response = HTTParty.get("https://api.import.io/store/data/fd9f53e1-4cbd-4642-b5e8-01d2dd6cb6fc/_query?input/webpage/url=#{metacritic_url}&_user=#{user}&_apikey=#{api_key}")
			if response['results'] != []
				if !response['results'][0]['score'].nil?
					score = response['results'][0]['score']
					self.metacritic_score = score
					if self.save
						logger.info "Metacritic Score: #{self.metacritic_score}"
					else
						logger.error "ERROR: failed to save metacritic score"
					end
				else
					logger.info "No Metascore found."
				end
			else
				logger.error "ERROR: Failed to find Metacritic Score"
			end
		else
			logger.info "Already have Metacritic Score"
			return self.metacritic_score
		end
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
		        release_year: result['year'],
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
		        available_since: DateTime.strptime(result['available_since'], "%b %d, %Y"),
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

	def self.hbo
		# http://catalog.lv3.hbogo.com/apps/mediacatalog/rest/productBrowseService/HBO/category/INDB487

		response = HTTParty.get("http://catalog.lv3.hbogo.com/apps/mediacatalog/rest/productBrowseService/HBO/category/INDB487.json")
		response['response']['body']['productResponses']['featureResponse']
		@results = response['response']['body']['productResponses']['featureResponse']

		@results.each do |result|
			
			# connect hbo data to an actual movie (need master movie list [imdb])
			imdb_id = result.omdb_search(result['title'], result['year'])[:imdb_id]
			
			# if movie isn't already in movie table
			unless Movie.find_by_imdb_id(imdb_id)
				# add to movie table
			end
			
			# add movie to hbo db


			# result['title']
			# result['year']
			# result['hboInternalId']
			# result['startDate']
			# result['endDate']
			# result['videoAvailable']

			# result['shortSummary']
			# result['summary']
			# result['TKey']
			# result['language']
			# result['focusId']
			# result['evergreen']

		end
		
	end

	# OMDB API (imdb)
	def self.omdb_search(title, year)
		title = CGI.escape(title)
		# http://www.omdbapi.com/?t=the matrix&y=1999&type=movie&tomatoes=true
		response = HTTParty.get("http://www.omdbapi.com/?t=#{title}&y=#{year}&type=movie&tomatoes=true")
		movie = { title: response['Title'],
							year: response['Year'],
							rating: response['Rated'],
							released: response['Released'],
							runtime: response['Runtime'],
							metacritic: response['Metascore'],
							imdb: response['imdbRating'],
							imdb_id: response['imdbID'],
							rt_meter: response['tomatoMeter'],
							rt_user: response['tomatoUserMeter']
						}
	end
		 
end
