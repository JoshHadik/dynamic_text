require 'dynamic_text/engine'
require 'dynamic_text/view_renderer'
require 'dynamic_text/locals_setter'
require 'configuron'

module DynamicText
  extend Configuron::Configurable
  require_relative 'dynamic_text/configuration'
end
