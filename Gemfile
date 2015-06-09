source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'bootstrap-sass', '~> 3.1.1'            # Bootstrap integration
gem 'faker', '1.1.2'                        # Create fake names for db seed
gem 'will_paginate', '3.0.4'                # Pagination
gem 'bootstrap-will_paginate', '~> 0.0.10'  # Bootstrap pagination support
gem 'autoprefixer-rails', '~> 4.0.2'        # Auto add all CSS browser prefixes

gem 'mixpanel-ruby', '~> 1.6.0'             # mixpanel back-end analytics
gem 'gabba', '~> 1.0.1'                     # Server-side google analytics
gem 'figaro', '~> 1.0.0'                    # Manage ENV Variables

gem 'themoviedb', '~> 0.1.0'                # Ruby wrapper for the movie database API
gem 'imdb', '~> 0.8.2'                      # Ruby wrapper for IMDB API (uses Nokogiri)
gem 'badfruit', '~> 1.1.2'                  # Rotten Tomatoes API
gem 'metacritic', '~> 0.1.1'                # Metacritic API
gem 'filmbuff', '~> 0.1.6'                  # IMDB API #2 (uses JSON API)


group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'


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

