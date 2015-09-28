class AddNetflixMoviesTable < ActiveRecord::Migration
  def change
		create_table :hbo_movies do |t|
		  t.integer :movie_id
		  t.boolean :available
		  t.datetime :available_since
		  t.datetime :expires
		  t.string :provider_id
		  t.string :page_link
		  t.string :play_link
		  t.string :queue_link
		  t.string :stream_quality
		  t.string :summary
		  t.string :short_summary
		  t.string :format_id

		  t.timestamps null: false
		end
		add_index :hbo_movies, :movie_id
  end
end
