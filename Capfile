require "capistrano/node-deploy"
require "capistrano/shared_file"

set :application, "blog"
set :user, "cgenco"
set :port, 42663
set :deploy_to, "/home/#{user}/apps/#{application}"

set :node_user, "remote-user"
set :node_env, "production"

set :scm, :git
set :repository,  "https://github.com/christiangenco/christiangenco.git"
# set :deploy_via, :rsync_with_remote_cache
set :deploy_via, :remote_cache

role :app, "gen.co"

set :shared_files,    ["config.js"]
set :shared_children, ["content/data", "content/images"]

set :keep_releases, 5

namespace :deploy do
  task :mkdir_shared do
    run "cd #{shared_path} && mkdir -p data images files"
  end

  task :setup_config, roles: :app do
    sudo "ln -nfs #{current_path}/nginx.conf /etc/nginx/sites-enabled/#{application}"
  end
  after "deploy:setup", "deploy:setup_config"
end



after "deploy:create_symlink", "deploy:mkdir_shared"