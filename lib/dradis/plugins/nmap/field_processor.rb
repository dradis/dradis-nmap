module Dradis
  module Plugins
    module Nmap
      class FieldProcessor < Dradis::Plugins::Upload::FieldProcessor
        def post_initialize(args={})
          if data.kind_of?(::Nmap::Host) || data.kind_of?(::Nmap::Port)
            @nmap_object = data
          elsif data.name == 'host'
            @nmap_object = ::Nmap::Host.new(data)
          elsif data.name == 'port'
            @nmap_object = ::Nmap::Port.new(data)
          end
        end

        def value(args={})
          field = args[:field]
          # fields in the template are of the form <foo>.<field>, where <foo>
          # is common across all fields for a given template (and meaningless).
          type, name, attribute = field.split('.')
          if type == 'host'
            host_value(name)
          elsif type == 'port'
            port_value(name, attribute)
          end
        end

        private
        def host_value(name)
          if name == 'hostnames'
            @nmap_object.hostnames.uniq.map(&:to_s).sort.join(', ')
          elsif name == 'service_table'
            host_service_table
          else
            @nmap_object.try(name) || 'n/a'
          end
        end

        def port_value(name, attribute = nil)
          if attribute
            # port.service.name
            # port.service.product
            # port.service.version
            if @nmap_object.service
              if attribute == 'tunnel'
                @nmap_object.service.try(:ssl?) ? 'ssl' : 'n/a'
              else
                @nmap_object.service.try(attribute) || 'n/a'
              end
            end
          else
            @nmap_object.try(name) || 'n/a'
          end
        end

        def host_service_table
          ports = []
          # Build up a Services table with all the available information about each
          # individual port.
          @nmap_object.each_port do |port|
            port_info = ''
            port_info << "| #{port.number} | #{port.protocol} | #{port.state} (#{port.reason}) |"
            if (srv = port.service)
              port_info << " #{srv.try('name') || ''} |"
              port_info << " #{srv.try('product') || ''} |"
              port_info << " #{srv.try('version') || ''} |"
            else
              port_info << "  |  |  |"
            end
            port_info << "\n"
            ports << port_info
          end
          ports.join
        end

      end
    end
  end
end
