module DynamicText
  module ViewHelper
    def dynamic_text_for(resource, attribute, opts={})
      DynamicText::ViewRenderer.new(self)
        .render_dynamic_text_for(resource, attribute, opts)
    end

    def editable_text_for(resource, attribute, opts={})
      DynamicText::ViewRenderer.new(self)
        .render_editable_text_for(resource, attribute, opts)
    end
  end
end
