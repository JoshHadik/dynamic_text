class DynamicText::Configuration
  attr_reader :resource_scope

  def initialize
    @resource_scope = nil
    @use_default_style = false
  end

  def resource_scope=(resource_scope)
    @resource_scope = "/#{resource_scope}"
  end

  def use_default_style!
    @use_default_style = true
  end

  def use_default_style?
    return @use_default_style 
  end
end
