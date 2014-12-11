set :stage, :staging

server 'geniilabs.in', user: 'webadmin', roles: %w{web app db}, runner: 'webadmin'