set :stage, :staging
set :branch, 'master'
set :rails_env, :staging

server 'geniilabs.in', user: 'webadmin', roles: %w{web app db}, runner: 'webadmin'