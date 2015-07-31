class ChangeRealeaseYearToInt < ActiveRecord::Migration
  def change
  	add_column :movies, :release_year, :integer
  	remove_column :movies, :release_date, :datetime
  end
end
