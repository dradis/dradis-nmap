module Dradis::Plugins::Nmap
  class Importer < Dradis::Plugins::Upload::Importer
    # The framework will call this function if the user selects this plugin from
    # the dropdown list and uploads a file.
    # @returns true if the operation was successful, false otherwise
    def import(params={})

      logger.info{ "Parsing Nmap output from #{ params[:file] }..." }
      doc = Nmap::XML::new(params[:file])
      logger.info{ 'Done.' }

      logger.info{ 'Validating Nmap output...' }
      if doc.hosts.empty?
        error = {
          'Title' => 'Invalid file format',
          'File name' => File.basename(params[:file]),
          'Description' => "The file you uploaded doesn't seem to be a valid Nmap XML file."
        }
        logger.fatal{ error['Description'] }
        error = error.map{|k,v| "#[%s]#\n%s\n" % [k, v] }.join("\n\n")
        content_service.create_note text: error
        return false
      end
      logger.info{ 'Done.' }

      # TODO: do something with the Nmap::Parser::Session information
      port_notes_to_add = {}

      doc.each_host do |host|
        host_label = host.ip
        host_node = content_service.create_node(label: host_label, type: :host)
        logger.info{ "New host: #{ host_label }" }

        # Set basic host properties
        host_node.set_property(:ip, host.ip)
        host_node.set_property(:hostname, host.hostnames.map(&:name)) if host.hostnames.present?
        host_node.set_property(:os, host.os.matches.map(&:name)) if host.os.present?

        # Old-style properties-in-a-note approach
        host_text = template_service.process_template(template: 'host', data: host)
        content_service.create_note(text: host_text, node: host_node)

        host.each_port do |port|
          logger.info { "\tNew port: #{port.number}/#{port.protocol}" }

          service = {
            port: port.number,
            protocol: port.protocol.to_s,
            state: port.state.to_s,
            reason: port.reason,
            name: port.try(:service).try(:name),
            product: port.try(:service).try(:product),
            tunnel: port.try(:service).try(:tunnel),
            version: port.try(:service).try(:version),
            source: :nmap,
          }

          # Node#set_service will store these under
          # Node#properties[:service_extras]:
          port.scripts.each { |k, v| service[k] = v } if port.try(:scripts)

          host_node.set_service(service)

          # HACK: patch in a `host` method to `Nmap::Port`
          # so we can use it in the template:
          port.class.module_eval { attr_accessor :host }
          port.host = host.ip

          # Add a note with the port information
          port_text = template_service.process_template(template: 'port', data: port)
          content_service.create_note(
            text: port_text,
            node: host_node)
        end

        host_node.save
      end
    end
  end
end
