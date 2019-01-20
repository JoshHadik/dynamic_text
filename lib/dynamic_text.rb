require 'dynamic_text/engine'
require 'configuron'

module DynamicText
  extend Configuron::Configurable
  require_relative 'dynamic_text/configuration'
end
