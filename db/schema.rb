# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150928184005) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "hbo_movies", force: :cascade do |t|
    t.integer  "movie_id"
    t.boolean  "available"
    t.datetime "available_since"
    t.datetime "expires"
    t.string   "provider_id"
    t.string   "page_link"
    t.string   "play_link"
    t.string   "queue_link"
    t.string   "stream_quality"
    t.string   "summary"
    t.string   "short_summary"
    t.string   "t_key"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "hbo_movies", ["movie_id"], name: "index_hbo_movies_on_movie_id", using: :btree

  create_table "movies", force: :cascade do |t|
    t.string   "title"
    t.string   "director"
    t.string   "poster_url"
    t.integer  "runtime"
    t.string   "imdb_id"
    t.integer  "tmdb_id"
    t.string   "synopsis"
    t.string   "tagline"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "content_rating"
    t.float    "netflix_score"
    t.integer  "rt_score"
    t.integer  "rt_audience"
    t.integer  "metacritic_score"
    t.float    "imdb_score"
    t.integer  "release_year"
  end

  add_index "movies", ["title"], name: "index_movies_on_title", using: :btree

  create_table "netflix_movies", force: :cascade do |t|
    t.integer  "movie_id"
    t.boolean  "available"
    t.datetime "available_since"
    t.datetime "expires"
    t.string   "provider_id"
    t.string   "page_link"
    t.string   "play_link"
    t.string   "queue_link"
    t.string   "stream_quality"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "netflix_movies", ["movie_id"], name: "index_netflix_movies_on_movie_id", using: :btree

  create_table "provider_movie", id: false, force: :cascade do |t|
    t.integer "provider_id", null: false
    t.integer "movie_id",    null: false
  end

  add_index "provider_movie", ["movie_id", "provider_id"], name: "index_provider_movie_on_movie_id_and_provider_id", using: :btree
  add_index "provider_movie", ["provider_id", "movie_id"], name: "index_provider_movie_on_provider_id_and_movie_id", using: :btree

  create_table "providers", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
