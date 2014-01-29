set :application, "christiangenco"
set :domain, "gen.co"
set :user, "cgenco"
set :port, 42663
set :deploy_to, "/home/#{user}/#{application}"
set :use_sudo, false
set :deploy_via, :remote_cache
set :scm, :git
set :repository, "git@github.com:christiangenco/christiangenco.git"
default_run_options[:pty] = true
set :normalize_asset_timestamps, false
 
role :app, domain
role :web, domain
role :db,  domain, :primary => true
 
# keep only the last 5 releases
after "deploy", "deploy:cleanup" 
set :keep_releases, 5

set :shared_children, ["content/data", "content/images"]

namespace :deploy do
  desc "Stop Forever"
  task :stop do
    run "cd #{current_path} && forever stop index.js; true"
  end
 
  desc "Start Forever"
  task :start do
    run "cd #{current_path} && NODE_ENV=production forever start index.js"
  end
 
  desc "Restart Forever"
  task :restart do
    stop
    sleep 5
    start
  end
 
  desc "Refresh shared node_modules symlink to current node_modules"
  task :refresh_symlink do
    run "mkdir -p #{shared_path}/node_modules"
    run "rm -rf #{current_path}/node_modules && ln -s #{shared_path}/node_modules #{current_path}/node_modules"
  end
 
  desc "Install node modules non-globally"
  task :npm_install do
    run "cd #{current_path} && npm install"
  end
end

after "deploy:update", "deploy:refresh_symlink", "deploy:npm_install"