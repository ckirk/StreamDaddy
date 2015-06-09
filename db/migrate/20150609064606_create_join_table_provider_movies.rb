class CreateJoinTableProviderMovies < ActiveRecord::Migration
  def change
    create_join_table :providers, :movies, table_name: :provider_movie do |t|
      t.index [:provider_id, :movie_id]
      t.index [:movie_id, :provider_id]
    end
  end
end
