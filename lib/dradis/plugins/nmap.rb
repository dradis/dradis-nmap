module Dradis
  module Plugins
    module Nmap
    end
  end
end

require 'dradis/plugins/nmap/engine'
require 'dradis/plugins/nmap/field_processor'
require 'dradis/plugins/nmap/importer'
require 'dradis/plugins/nmap/version'

# This is required while we transition the Upload Manager to use
# Dradis::Plugins only
module Dradis
  module Plugins
    module Nmap
      module Meta
        NAME = "Nmap XML upload plugin"
        EXPECTS = "Nmap results XML. Use nmap with the -oX <file>.xml argument."
        module VERSION
          include Dradis::Plugins::Nmap::VERSION
        end
      end
    end
  end
end
