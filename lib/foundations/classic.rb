module Waves
  module Foundations
    
    # Provides Sun MVC features for your application.
    # Includes ERb-style templates. You can also include others via Renderer Layers.
    # It does NOT include a default ORM. Use an ORM Layer for that.
    
    module Classic

      def self.included( app )

        require 'autocode'
        require 'layers/mvc'
        require 'layers/inflect/english'
        require 'helpers/extended'
        require 'layers/renderers/erubis'
        require 'layers/renderers/markaby'
        
        app.module_eval do

          include AutoCode
          
          app.auto_create_module( :Configurations ) do
            include AutoCode
            auto_create_class :Default, Waves::Configurations::Default
            auto_load :Default, :directories => [ :configurations ]
          end

          app.auto_eval( :Configurations ) do
            auto_create_class true, app::Configurations::Default
            auto_load true, :directories => [ :configurations ]
          end

          app.auto_create_module( :Resources ) do
            include AutoCode
            auto_create_class :Default, Waves::Resources::Base
            auto_load :Default, :directories => [ :resources ]
          end

          app.auto_eval( :Resources ) do
            auto_create_class true, app::Resources::Default
            auto_load true, :directories => [ :resources ]
            auto_eval :Map do
              
              handler( Waves::Dispatchers::NotFoundError ) do
                app::Views::Errors.new( request ).not_found_404
              end

            end
          end

          include Waves::Layers::Inflect::English
          include Waves::Layers::MVC
          include Waves::Renderers::Erubis   
          include Waves::Renderers::Markaby   
          
        end
        
        Waves << app
        
      end
    end
  end
end


