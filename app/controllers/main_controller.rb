class MainController < ApplicationController
  def index
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

    @movies.each do |m|
      if Movie.find_by_title(m["title"]).nil?
        Movie.create(
          title: m["title"],
          overview: m["synopsis"]
        )
      end
    end

    @films = Movie.all


    # "title"=>"009-1: The End of the Beginning",
    # "synopsis"=>"A female cyborg spy designed to be a cold-hearted killing machine sets out to bust a human trafficking ring and rescue the scientist who created her.",
    # "thumbnail"=>"http://cdn0.nflximg.net/images/8786/21258786.jpg",
    # "year"=>2013.0,
    # "rating"=>"NR",
    # "runtime"=>85.0,
    # "quality"=>"SuperHD",
    # "netflix_rating"=>2.6,
    # "netflix_page"=>"http://www.netflix.com/title/80048948",
    # "play_link"=>"http://www.netflix.com/watch/80048948?devKey=mvxgt6dvdvkdabunfb9s2ajq&nbb=y",
    # "available_since"=>"Jun 01 '15",

  end
end
