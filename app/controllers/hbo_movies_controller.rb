class HboMoviesController < ApplicationController

	def index
		@movies = HboMovie.all.includes(:movie).order(created_at: :desc).paginate(:page => params[:page], :per_page => 50)
	end

end