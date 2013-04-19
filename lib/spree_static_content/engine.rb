module SpreeStaticContent

  mattr_accessor :redirect_slug_case_mismatches

  class Engine < Rails::Engine
    engine_name 'spree_static_content'

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../../app/**/*_decorator*.rb")) do |c|
        Rails.application.config.cache_classes ? require(c) : load(c)
      end
    end

    initializer "redirect middleware" do |app|
      app.middleware.insert_after ::ActionDispatch::DebugExceptions, ::SpreeStaticContent::RedirectMiddleware
    end

    config.to_prepare &method(:activate).to_proc
    config.autoload_paths += %W(#{config.root}/lib)
  end
end
