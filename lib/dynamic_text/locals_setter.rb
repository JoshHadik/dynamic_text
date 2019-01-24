class DynamicText::LocalsSetter
  def set_dynamic_template_locals(resource, attribute, opts={})
    Hash.new.tap do |locals|
      locals[:resource] = resource
      locals[:attribute] = attribute
      locals[:value] = resource.send(attribute)
      locals[:placeholder] = opts[:placeholder] || "Enter #{attribute}..."
      locals[:resource_type] = expected_resource_type(resource)
      locals[:dynamic_tag] =
        default_dynamic_tag(locals[:resource_type], resource.id, attribute)
    end
  end

  def set_editable_template_locals(resource, attribute, opts={})
    set_dynamic_template_locals(resource, attribute, opts={}).tap do |locals|
      opts[:url] ||= expected_path_for(locals[:resource_type], resource)
      opts[:ajax_key] ||=
        default_ajax_key(locals[:resource_type], attribute)
      locals[:url] = opts[:url]
      locals[:ajax_key] = opts[:ajax_key]
    end
  end

  private

  def resource_scope
    @resource_scope ||= DynamicText.configuration.resource_scope
  end

  def expected_path_for(resource_type, resource)
    "#{resource_scope}/#{resource_type.pluralize}/#{resource.id}"
  end

  def expected_resource_type(resource)
    resource.class.name.downcase
  end

  def default_dynamic_tag(resource_type, resource_id, attribute)
    "#{resource_type}:#{resource_id}:#{attribute}"
  end

  def default_ajax_key(resource_type, attribute)
    "#{resource_type}:#{attribute}"
  end
end
