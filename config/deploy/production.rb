set :stage, :production
set :branch, 'master'
set :rails_env, :production

server ENV['PROD_SERVER'], user: ENV['PROD_USER'], roles: %w{web app db}, runner: ENV['PROD_USER']
