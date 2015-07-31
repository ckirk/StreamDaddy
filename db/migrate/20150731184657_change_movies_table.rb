class ChangeMoviesTable < ActiveRecord::Migration
  def change
  	rename_column :movies, :overview, :synopsis
  	add_column :movies, :content_rating, :string
  	add_column :movies, :netflix_score, :integer
  	add_column :movies, :rt_score, :integer
  	add_column :movies, :rt_audience, :integer
  	add_column :movies, :metacritic_score, :integer
  	add_column :movies, :imdb_score, :integer
  	# remove_column :movies, :column_name, :type, :options
  	# change_column :movies, :column_name, :date

  	create_table :netflix_movies do |t|
  	  t.integer :movie_id
  	  t.boolean :available
  	  t.datetime :available_since
  	  t.datetime :expires
  	  t.string :provider_id
  	  t.string :page_link
  	  t.string :play_link
  	  t.string :queue_link
  	  t.string :stream_quality

  	  t.timestamps null: false
  	end
  	add_index :netflix_movies, :movie_id
  end
end
