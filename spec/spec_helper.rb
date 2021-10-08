# frozen_string_literal: true

require 'pay_with_me'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr_cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
end

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'

  config.before do
    PayWithMe.config do |c|
      c.configure :perfect_money do |pm|
        pm.account_id 42
        pm.password 'password'
        pm.sci_salt 'm9O2768ZuMFVvWphuPJVJJfRX'
      end
    end
  end
end
