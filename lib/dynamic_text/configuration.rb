class DynamicText::Configuration
  attr_reader :resource_scope

  def initialize
    @resource_scope = nil
    @use_default_style = false
  end

  # Set a custom scope for the default resource path (in case your Rails app uses something other than the default path)
  def resource_scope=(resource_scope)
    @resource_scope = "/#{resource_scope}"
  end

  # Use the dynamic text default style for editable text boxes
  def use_default_style!
    @use_default_style = true
  end

  # Check if using default style
  def use_default_style?
    return @use_default_style
  end
end
