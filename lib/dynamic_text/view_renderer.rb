class DynamicText::ViewRenderer < AbstractController::Base
  def initialize(controller)
    @controller = controller
  end

  def render_dynamic_text_for(resource, attribute, opts={})
    locals = dynamic_locals(resource, attribute, opts)
    render_dynamic_text(**locals)
  end

  def render_editable_text_for(resource, attribute, opts={})
    locals = editable_locals(resource, attribute, opts)
    render_editable_text(**locals)
  end

  private

  def dynamic_locals(resource, attribute, opts={})
    locals_setter.set_dynamic_template_locals(resource, attribute, opts)
  end

  def editable_locals(resource, attribute, opts={})
    locals_setter.set_editable_template_locals(resource, attribute, opts)
  end

  def locals_setter
    DynamicText::LocalsSetter.new
  end

  def render_editable_text(options)
    render_partial(:editable_text, **options)
  end

  def render_dynamic_text(options)
    render_partial(:dynamic_text, **options)
  end

  def render_partial(partial, **locals)
    @controller.render partial: "dynamic_text/#{partial}", locals: locals
  end
end
