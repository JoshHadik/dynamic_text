class DynamicText::Configuration
  attr_reader :resource_scope

  def initialize
    @resource_scope = nil
  end

  def resource_scope=(resource_scope)
    @resource_scope = "/#{resource_scope}"
  end
end
