$LOAD_PATH.unshift(File.dirname(__FILE__))
ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../dummy/config/environment.rb', __FILE__)

# nasty hacky catch of environment data wiped out by tests run in rails 4 via appraisal
if ActiveRecord::VERSION::STRING >= '5.0'
  system('bin/rails dummy:db:environment:set RAILS_ENV=test')
end

require 'rspec/rails'
require 'shoulda-matchers'
require 'factory_bot'

Rails.backtrace_cleaner.remove_silencers!

#
# Require test support, factories.
#
Dir[File.join(File.dirname(__FILE__), 'factories/**/*.rb')].each { |f| require f }

# Build test database in spec/dummy/db/
if defined?(ActiveRecord::Migration.maintain_test_schema!)
  ActiveRecord::Migration.maintain_test_schema! # rails 4.1+
else
  ActiveRecord::Migration.check_pending! # rails 4.0
end

if ActiveRecord::VERSION::STRING >= '4.2' && ActiveRecord::VERSION::STRING < '5.0'
  ActiveRecord::Base.raise_in_transactional_callbacks = true
end

# puts 'MAJOR:' + Rails::VERSION::MAJOR.to_s

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.infer_spec_type_from_file_location!
  config.order = :random
  config.use_transactional_fixtures = true

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
  end
end

def mock_request(params = {})
  req = double('request')
  allow(req).to receive(:params).and_return(params)
  allow(req).to receive(:remote_ip).and_return('111.111.111.111')
  req
end

