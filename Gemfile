source 'https://rubygems.org'

gem 'rails', '4.2.0'
gem 'pg'                                    # Use postgresql as the database for Active Record
gem 'sass-rails', '~> 5.0.3'                # Use SCSS for stylesheets
gem 'uglifier', '>= 1.3.0'                  # Use Uglifier as compressor for JavaScript assets
gem 'coffee-rails', '~> 4.1.0'              # Use CoffeeScript for .coffee assets and views
gem 'jquery-rails'                          # Use jquery as the JavaScript library
gem 'turbolinks'                            # Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'jbuilder', '~> 2.0'                    # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'sdoc', '~> 0.4.0', group: :doc         # bundle exec rake doc:rails generates the API under doc/api.
gem 'bcrypt', '~> 3.1.7'                    # Use ActiveModel has_secure_password
#gem 'unicorn'                              # Use Unicorn as the app server
#gem 'therubyracer', platforms: :ruby       # See https://github.com/sstephenson/execjs#readme for more supported runtimes

gem 'bootstrap-sass', '~> 3.3.5.1'          # Bootstrap integration
gem 'font-awesome-rails', '~> 4.3.0.0'      # Font-Awesome font icons for rails asset pipeline
gem 'will_paginate', '3.0.7'                # Pagination
gem 'bootstrap-will_paginate', '~> 0.0.10'  # Bootstrap pagination support
gem 'autoprefixer-rails', '~> 5.2.1'        # Auto add all CSS browser prefixes
gem 'faker', '1.1.2'                        # Create fake names for db seed
gem 'figaro', '~> 1.1.1'                    # Manage ENV Variables

gem 'importio', '~> 2.0.1'                  # Import.io gem by Import.io
gem 'httparty', '~> 0.13.5'                 # http requets

gem 'mixpanel-ruby', '~> 1.6.0'             # mixpanel back-end analytics
gem 'gabba', '~> 1.0.1'                     # Server-side google analytics

# gem 'themoviedb', '~> 0.1.0'                # Ruby wrapper for the movie database API
# gem 'badfruit', '~> 1.1.2'                  # Rotten Tomatoes API
# gem 'metacritic', '~> 0.1.1'                # Metacritic API
gem 'imdb', '~> 0.8.2'                      # Ruby wrapper for IMDB API (uses Nokogiri - more popular)
# gem 'filmbuff', '~> 0.1.6'                  # IMDB API #2 (uses JSON API - maybe faster?)
gem 'worth_watching', '~> 1.0.0'            # IMDB, Metacritic, and Rotten Tomatoes Reviews
gem 'tmdb_party', '~> 0.9.0'


group :development, :test do
  gem 'byebug'                              # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'web-console', '~> 2.0'               # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'spring'                              # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  #gem 'capistrano-rails'                   # Use Capistrano for deployment

  gem 'rails-dev-tweaks', '~> 1.1'
  gem 'quiet_assets', '~> 1.0.3'            # gets rid of annoying lines in terminal
  gem 'hirb', '~> 0.7.3'                    # better table view in rails console

  # Debugging tools
  gem 'better_errors', '~> 2.0.0'           # improved error information
	gem 'binding_of_caller', '~> 0.7.2'       # adds more detail to better_errors
  gem 'pry-rails', '~> 0.3.2'               # interactive debugging tool
  gem 'bullet', '~> 4.14.0'                 # tests for N+1 query problems
  gem 'meta_request', '~> 0.3.4'            # required for RailsPanel (chrome extension) to work
end

group :production do
  gem 'rails_12factor'                      # for heroku to work
  gem 'newrelic_rpm'                        # for New Relic to work
  gem 'unicorn', '4.8.3'                    # Unicorn production server
end

