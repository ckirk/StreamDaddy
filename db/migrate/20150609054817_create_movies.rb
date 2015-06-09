class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :title
      t.string :director
      t.datetime :release_date
      t.string :poster_url
      t.integer :runtime
      t.string :imdb_id
      t.integer :tmdb_id
      t.string :overview
      t.string :tagline

      t.timestamps null: false
    end
    add_index :movies, :title
  end
end
