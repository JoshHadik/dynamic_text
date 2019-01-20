class DynamicText::Configuration
  attr_reader :path_prefix

  def initialize
    @path_prefix = nil
  end

  def path_prefix=(prefix)
    @path_prefix = "#{prefix}_"
  end
end
