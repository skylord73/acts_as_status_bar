# Configure Rails Envinronment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"

ActionMailer::Base.delivery_method = :test
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.default_url_options[:host] = "test.com"

Rails.backtrace_cleaner.remove_silencers!

# Configure capybara for integration testing
require "capybara/rails"
Capybara.default_driver   = :rack_test
Capybara.default_selector = :css

# Run any available migration
ActiveRecord::Migrator.migrate File.expand_path("../dummy/db/migrate/", __FILE__)

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

class ActiveSupport::TestCase
  

    class << self
     def my_load_fixtures
        Dir["#{File.dirname(__FILE__)}/fixtures/**/*.yml"].each do |file|
          fixtures = YAML.load_file(file)
          #puts file.gsub("\.yml","").gsub("\.\/test\/fixtures\/","").singularize.camelize
          model = file.gsub("\.yml","").gsub("\.\/test\/fixtures\/","").singularize.camelize.constantize
          model.delete_all
          #Remove protected_attribute to allow seeding of every field... you know what you do!
          model.protected_attributes.each { |attribute| model.protected_attributes.delete(attribute)}
          fixtures.each {|k,fixture| model.new.update_attributes(fixture)}
          puts "#{model.count} Fixtures loaded for  #{model.name}"
        end
      end
    end
    my_load_fixtures
  
end
