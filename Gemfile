source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.11.1'

# Use mysql as the database for Active Record
gem 'mysql2'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use jquery as the JavaScript library
gem 'jquery-rails', '= 3.1.3'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

gem 'figaro'

gem 'devise', '~> 3.5.0'

gem 'haml-rails', '~> 0.6'

# http://fullscreen.github.io/bh/#overview
gem 'bh', '~> 1.2'

gem 'momentjs-rails', '>= 2.8.1'
gem 'bootstrap3-datetimepicker-rails', '~> 3.1.3'


gem 'ransack', '~> 1.8.7'
gem 'simple_form'
gem 'nested_form'
gem 'rabl'

gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'

# To annotate only models: annotate --exclude tests,fixtures,factories
gem 'annotate', '>=2.6.0'

gem 'jquery-turbolinks'
gem 'passenger', '~> 4.0.53'
gem 'countries'
gem 'country_select'
gem 'paper_trail', '~> 3.0.7'
gem 'kaminari'
gem 'kaminari-bootstrap', '~> 3.0.1'
gem 'select2-rails'
gem 'faker'

gem 'rollbar', '~> 2.15.5'

gem 'paranoia', '~> 2.0'

gem 'responders', '~> 2.0' # https://guides.rubyonrails.org/upgrading_ruby_on_rails.html#responders

group :development do
  # Removes assets request logs
  gem 'quiet_assets'

  # rails_best_practices -f html .
  gem 'rails_best_practices'

  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  gem 'web-console', '~> 2.0'
end

group :development, :test do
  gem 'byebug'
  gem 'ruby-debug-passenger'
  gem 'minitest-reporters'

  # Preview email in the browser without setting up email system
  gem 'letter_opener'
  # Detect unused eager loading and log N+1 queries
  gem 'bullet'
  # Profiling middleware for development
  gem 'rack-mini-profiler', "~> 0.10"
  # Enforce ruby style guide
  gem 'rubocop', '~> 0.39', require: false
end
