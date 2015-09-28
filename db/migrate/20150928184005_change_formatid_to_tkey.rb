class ChangeFormatidToTkey < ActiveRecord::Migration
  def change
  	rename_column :hbo_movies, :format_id, :t_key
  end
end
