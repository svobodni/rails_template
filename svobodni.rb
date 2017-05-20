def source_paths
  [File.expand_path(File.dirname(__FILE__))]
end

after_bundle do
  git :init
  git add: "."
  git commit: %Q{ -m 'Rails generated skeleton' }

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
  copy_file "templates/development.rb", "config/configatron/development.rb", force: true

  route "get '/auth/:provider/callback', to: 'sessions#create'"
  route "get '/sessions/destroy'"

  git add: "."
  git commit: %Q{ -m 'Configured for registr outh2' }

  copy_file "templates/application.html.erb", "app/views/layouts/application.html.erb"
  generate(:controller, "welcome ahoj")
  route "root to: 'welcome#ahoj'"
end
