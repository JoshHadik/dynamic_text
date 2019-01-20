module DynamicText
  class Engine < ::Rails::Engine
    config.assets.precompile += %w(dynamic_text)
    isolate_namespace DynamicText

    initializer 'local_helper.action_controller' do
      ActiveSupport.on_load :action_controller do
        helper DynamicText::ViewHelper
      end
    end
  end
end
