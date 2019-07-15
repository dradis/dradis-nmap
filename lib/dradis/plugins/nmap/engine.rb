module Dradis
  module Plugins
    module Nmap
      class Engine < ::Rails::Engine
        isolate_namespace Dradis::Plugins::Nmap

        include ::Dradis::Plugins::Base
        description 'Processes Nmap output'
        provides :upload

        initializer 'dradis-nmap.tunnel_attribute' do
          ::Nmap::Service.include Dradis::Plugins::Nmap::Tunnel
        end
      end
    end
  end
end
