set :stage, :staging

server 'geniilabs.in', user: ENV['STAGING_SERVER_USERNAME'], roles: %w{web app db}, runner: ENV['STAGING_SERVER_USERNAME'], password: ENV['STAGING_SERVER_PASSWORD']