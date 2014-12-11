# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'balasha'
set :repo_url, 'https://github.com/geniitech/bal-asha.git'
set :stages, %w(production staging)
set :deploy_to, "/home/webadmin/sites/#{fetch(:application)}"
set :user, "webadmin"
set :ssh_options, {
  forward_agent: true
}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/assets}

# Default value for keep_releases is 5
set :keep_releases, 5

namespace :setup do
  desc "Create deploy directory"
  task :create_directory do
    on roles(:app) do
      execute :mkdir, '-p', deploy_to
      execute :chown, "#{fetch(:user)}", deploy_to
    end
  end
end

namespace :logs do
  desc "tail rails logs"
  task :tail do
    on roles(:app) do
      execute "tail -f #{shared_path}/log/#{fetch(:stage)}.log"
    end
  end
end

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      within release_path do
        execute :rake, 'tmp:clear'
      end
    end
  end
end


namespace :figaro do
  desc "SCP transfer figaro configuration to the shared folder"
  task :setup do
    on roles(:app) do
      upload! "config/application.yml", "#{shared_path}/application.yml", via: :scp
    end
  end

  desc "Symlink application.yml to the release path"
  task :symlink do
    on roles(:app) do
      execute "ln -sf #{shared_path}/application.yml #{current_path}/config/application.yml"
    end
  end
end
after "deploy:started", "figaro:setup"
after "deploy:symlink:release", "figaro:symlink"