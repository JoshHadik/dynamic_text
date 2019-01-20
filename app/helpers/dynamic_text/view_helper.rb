module DynamicText
  module ViewHelper
    def dynamic_text(text="", tag: "default", filler: "N/A")
      text = filler if !text || text.empty?
      content_tag(:span, text, class: "dynamic-text", data: {"dynamic-tag": tag})
    end

    def editable_text(text="", tag: "default", placeholder: "Enter text...")
      content_tag(:span, class: "editable-text-container") do
        content_tag(:span, text, class: "editable-text", contenteditable: true, placeholder: placeholder, data: {"dynamic-tag": tag})
      end
    end

    def dynamic_text_for(resource, attribute, options={})
      options = dynamic_attributes(resource, attribute, options)
      dynamic_text_tag(options)
    end

    def editable_text_for(resource, attribute, options = {})
      options = editable_attributes(resource, attribute, options)

      content_tag(:span, class: "editable-text-container") do
        editable_text_tag(options) +
        patch_request_tag(options)
      end
    end

    private

    def dynamic_attributes(resource, attribute, options={})
      Hash.new.tap do |hash|
        hash[:resource] = resource
        hash[:attribute] = attribute
        hash[:value] = resource.send(attribute)
        hash[:placeholder] = options[:placeholder] || "Enter #{attribute}..."
        hash[:resource_type] = expected_resource_type(resource)
        hash[:dynamic_tag] =
          default_dynamic_tag(hash[:resource_type], resource.id, attribute)
      end
    end

    def editable_attributes(resource, attribute, options={})
      dynamic_attributes(resource, attribute, options={}).tap do |hash|
        hash[:url] =
          options[:url] || send("#{DynamicText.configuration.path_prefix}#{hash[:resource_type]}_path", resource)
        hash[:ajax_key] =
          options[:ajax_key] || default_ajax_key(hash[:resource_type], attribute)
      end
    end

    def dynamic_text_tag(attributes)
      text = attributes[:value] || attributes[:placeholder]
      dynamic_text_attributes = {
        class: "dynamic-text",
        data: {"dynamic-tag": attributes[:dynamic_tag]}
      }

      content_tag(:span, text, dynamic_text_attributes)
    end

    def editable_text_tag(attributes)
      editable_text_attributes = {
        class: "editable-text",
        contenteditable: true,
        placeholder: attributes[:placeholder],
        data: {"dynamic-tag": attributes[:dynamic_tag]}
      }

      content_tag(:span, attributes[:value], editable_text_attributes)
    end

    def patch_request_tag(attributes)
      patch_request_attributes = {
        'url' => attributes[:url],
        'attribute' => attributes[:attribute],
        'resource-type' => attributes[:resource_type],
        'ajax-key' => attributes[:ajax_key]
      }

      hidden_field_tag("_action", "patch", patch_request_attributes)
    end

    def expected_resource_type(resource)
      resource.class.name.downcase
    end

    def expected_path(resource, resource_type=expected_type_for(resource))
      send("#{resource_type}_path", resource)
    end

    def default_dynamic_tag(resource_type, resource_id, attribute)
      "#{resource_type}:#{resource_id}:#{attribute}"
    end

    def default_ajax_key(resource_type, attribute)
      "#{resource_type}:#{attribute}"
    end
  end
end
