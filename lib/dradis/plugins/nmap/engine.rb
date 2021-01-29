module Dradis::Plugins::Nmap
  class Engine < ::Rails::Engine
    isolate_namespace Dradis::Plugins::Nmap

    include ::Dradis::Plugins::Base
    description 'Processes Nmap output'
    provides :upload
  end
end
