def source_paths
  [File.expand_path(File.dirname(__FILE__))]
end

after_bundle do
  git :init
  git add: "."
  git commit: %Q{ -m 'Rails generated skeleton' }

  oauth
  bootstrap
  welcome
end

def oauth
  # AUTH
  run 'spring stop'
  gem 'omniauth-oauth2'
  gem 'cancancan', '~> 1.10'
  gem 'configatron'
  run 'bundle'

  generate('cancan:ability')

  git add: "."
  git commit: %Q{ -m 'Added oauth2 and cancan' }

  copy_file "templates/registr.rb", "lib/omni_auth/strategies/registr.rb"
  copy_file "templates/application_controller.rb", "app/controllers/application_controller.rb"
  copy_file "templates/sessions_controller.rb", "app/controllers/sessions_controller.rb"
  copy_file "templates/omniauth.rb", "config/initializers/omniauth.rb"
  copy_file "templates/error.rb", "lib/oauth2/error.rb"

  generate('configatron:install')
  copy_file "templates/development.rb", "config/configatron/development.rb", {force: true}

  route "get '/auth/:provider/callback', to: 'sessions#create'"
  route "get '/sessions/destroy'"

  git add: "."
  git commit: %Q{ -m 'Configured for registr outh2' }
end

def bootstrap
  gem 'jquery-rails'
  gem 'bootstrap-sass', '~> 3.3.6'
  gem 'font-awesome-rails'
  run 'bundle'
  copy_file "templates/application.js", "app/assets/javascripts/application.js"
  copy_file "templates/bs-setup.scss", "app/assets/stylesheets/bs-setup.scss"
  copy_file "templates/Svobodni_logo_RGB.jpg", "app/assets/images/Svobodni_logo_RGB.jpg"
  #   gsub_file 'app/assets/stylesheets/application.css', "*= require_tree .", "@import \"bootstrap-sprockets\"
  # @import \"bootstrap\""
  #   gsub_file '', "//= require jquery", "//= require .bootstrap-sprockets"

  git add: "."
  git commit: %Q{ -m 'Added bootstrap' }
end

def welcome
  copy_file "templates/application.html.erb", "app/views/layouts/application.html.erb"
  generate(:controller, "welcome ahoj")
  route "root to: 'welcome#ahoj'"
end
