require 'pry'
require 'yaml'

RSpec.configure do |c|
  c.mock_with :rspec
end

require 'puppet'
require 'puppetlabs_spec_helper/module_spec_helper'

require_relative '../lib/jjb_utils'
