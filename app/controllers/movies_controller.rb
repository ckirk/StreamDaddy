class MoviesController < ApplicationController
  def index
  	@movies = Movie.all
  end

  def show
  end

  def test
		# Search Params
		page = 1
		content_type = "content_type=1"
		sort = "sort=available_from desc"
		view = "view=synopsis"

		url = CGI.escape("http://instantwatcher.com/search?page=#{page}&#{content_type}&#{sort}&#{view}")

		user = "8ef67b8a-116a-4c74-9dc8-8ea25812e8a3"
		api_key = "8ef67b8a116a4c749dc88ea25812e8a300a3cd5adc1ad5e037db4e05ddb64d8459a5fbe3e4dbb4f019289026606b5036f88372cfd840d269296d08b44e85fb3747a99697b100c6d9a8d62ef0452d4aa7"
		
		response = HTTParty.get("https://api.import.io/store/data/800dd083-18a5-4b58-99b2-98dd7f844a27/_query?input/webpage/url=#{url}&_user=#{user}&_apikey=#{api_key}")

	  @movies = response["results"]

    @movies.first do |movie|
      @title = movie["title"]
      @poster_url = movie["thumbnail"]
      @synopsis = movie["synopsis"]
      @director = movie["director"]
      @release_date = movie["year"]
      @release_year = movie["year/_source"] # string
      @runtime = movie["runtime"]
      @content_rating = movie["rating"]
      @netflix_score = movie["netflix_rating"]
      @rt_score = movie["rt_meter"]
      @rt_audience = movie["rt_audience"]

      @available = true
      @available_since = movie["available_since"]
      @page_link = movie["netflix_page"]
      @play_link = movie["play_link"]
      # @queue_link
      @stream_quality = movie["stream_quality"]
      @provider_id = @page_link.match(/netflix.com\/title\/([0-9]+)/).captures[0]

    end

  end

  def import

    pages = 5
    @imported_movies = []
    @skipped = 0
    @netflix_movie_created = 0

    # Search Params
    content_type = "content_type=1"
    sort = "sort=available_from desc"
    view = "view=synopsis"

    user = "8ef67b8a-116a-4c74-9dc8-8ea25812e8a3"
    api_key = "8ef67b8a116a4c749dc88ea25812e8a300a3cd5adc1ad5e037db4e05ddb64d8459a5fbe3e4dbb4f019289026606b5036f88372cfd840d269296d08b44e85fb3747a99697b100c6d9a8d62ef0452d4aa7"

    (1..pages).each do |page|
      url = CGI.escape("http://instantwatcher.com/search?page=#{page}&#{content_type}&#{sort}&#{view}")
      response = HTTParty.get("https://api.import.io/store/data/800dd083-18a5-4b58-99b2-98dd7f844a27/_query?input/webpage/url=#{url}&_user=#{user}&_apikey=#{api_key}")
    
      @results = response['results']

      @results.each do |result|
        if Movie.find_by_title(result['title']).nil?
          movie = Movie.create(
            title: result['title'],
            poster_url: result['thumbnail'],
            synopsis: result['synopsis'],
            director: result['director'],
            release_year: Time.at(result['year/_source'].to_f),
            ## release_date: result['year/_source'], # string
            runtime: result['runtime'],
            content_rating: result['rating'],
            netflix_score: result['netflix_rating'],
            rt_score: result['rt_meter'],
            rt_audience: result['rt_audience']
          )
          NetflixMovie.create(
            movie_id: movie.id,
            available: true,
            available_since: result['available_since'],
            page_link: result['netflix_page'],
            play_link: result['play_link'],
            stream_quality: result['stream_quality'],
            provider_id: result['netflix_page'].match(/netflix.com\/title\/([0-9]+)/).captures[0]
            ## queue_link
          )
          @imported_movies.push(result['title'])
          @netflix_movie_created += 1
        else
          @skipped += 1
        end
      end

    end

  end

end
