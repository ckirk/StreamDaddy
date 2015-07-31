class ChangeRatingsToDecimal < ActiveRecord::Migration
  def change
  	change_column :movies, :netflix_score, :float
  	change_column :movies, :imdb_score, :float
  end
end
