module Dradis
  module Plugins
    module Nmap
      module Tunnel
        def tunnel
          @tunnel ||= @node.get_attribute('tunnel')
        end
      end
    end
  end
end
