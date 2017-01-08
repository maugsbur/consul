Split.configure do |config|
  config.db_failover = true # handle redis errors gracefully
  config.db_failover_on_db_error = proc{|error| Rollbar.error("Redis is not running") }
end

if Rails.env.preproduction? || Rails.env.production?
  Split::Dashboard.use Rack::Auth::Basic do |username, password|
    username == Rails.application.secrets.a_b_testing_username &&
    password == Rails.application.secrets.a_b_testing_username.a_b_testing_password
  end
end