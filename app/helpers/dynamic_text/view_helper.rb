module DynamicText
  module ViewHelper
    # Render editable text view partial for attribute of resource
    def dynamic_text_for(resource, attribute, opts={})
      DynamicText::ViewRenderer.new(self)
        .render_dynamic_text_for(resource, attribute, opts)
    end

    # Render editable text view partial for attribute of resource
    def editable_text_for(resource, attribute, opts={})
      DynamicText::ViewRenderer.new(self)
        .render_editable_text_for(resource, attribute, opts)
    end
  end
end
