class DynamicText::LocalsSetter
  def initialize
    @locals = {}
  end

  def get_dynamic_locals(resource, attribute, opts={})
    @locals.merge!(opts).tap do |locals|
      locals[:resource] = resource
      locals[:attribute] = attribute
      locals[:resource_id] = resource.id
      locals[:value] ||= resource.send(attribute)
      locals[:resource_scope] ||= DynamicText.configuration.resource_scope
      locals[:placeholder] ||= default_placeholder
      locals[:resource_type] ||= default_resource_type
      locals[:resource_route] ||= default_resource_route
      locals[:dynamic_tag] ||= default_dynamic_tag
    end
  end

  def get_editable_locals(resource, attribute, opts={})
    get_dynamic_locals(resource, attribute, opts).tap do |locals|
      locals[:url] ||= default_url
      locals[:ajax_key] ||= default_ajax_key
    end
  end

  private

  # Defaults

  def default_placeholder
    "Enter #{get_local(:attribute)}..."
  end

  def default_resource_type
    get_local(:resource).class.name.downcase
  end

  def default_resource_route
    get_local(:resource_type).pluralize
  end

  def default_dynamic_tag
    get_locals(:resource_type, :resource_id, :attribute).join(":")
  end

  def default_url
    get_locals(:resource_scope, :resource_route, :resource_id).join("/")
  end

  def default_ajax_key
    get_locals(:resource_type, :attribute).join(":")
  end

  # Helpers

  def get_local(local_name)
    @locals[local_name]
  end

  def get_locals(*local_names)
    local_names.collect do |local_name|
      get_local(local_name)
    end
  end
end
