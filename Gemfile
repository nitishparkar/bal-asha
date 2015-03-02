source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.8'

# Use mysql as the database for Active Record
gem 'mysql2'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

gem 'figaro'

gem 'devise'

gem 'haml-rails'

# http://fullscreen.github.io/bh/#overview
gem 'bh', '~> 1.2'

gem 'momentjs-rails', '>= 2.8.1'
gem 'bootstrap3-datetimepicker-rails', '~> 3.1.3'


gem 'ransack', github: 'activerecord-hackery/ransack', branch: 'rails-4.1'
gem 'simple_form'
gem 'nested_form'
gem 'rabl'

# To annotate only models: annotate --exclude tests,fixtures,factories
gem 'annotate', '>=2.6.0'

gem 'jquery-turbolinks'
gem 'passenger'
gem 'countries'
gem 'country_select'
gem 'paper_trail', '~> 3.0.6'
gem 'kaminari'
gem 'kaminari-bootstrap', '~> 3.0.1'
gem 'select2-rails'
gem 'faker'

# Sending email notifications when errors occur
gem 'exception_notification'


group :development do
  # Removes assets request logs
  gem 'quiet_assets'

  gem 'rails_best_practices'
  gem 'capistrano', '~> 3.2.0'
  gem 'capistrano-rvm'

  # rails specific capistrano funcitons
  gem 'capistrano-rails', '~> 1.1.0'

  # integrate bundler with capistrano
  gem 'capistrano-bundler'

  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  gem 'capistrano-db-tasks', require: false
end

group :development, :test do
  gem 'byebug'
  gem 'ruby-debug-passenger'

  # Preview email in the browser without setting up email system
  gem 'letter_opener'
  # Detect unused eager loading and log N+1 queries
  gem 'bullet'
  # Profiling middleware for development
  gem 'rack-mini-profiler'
end


