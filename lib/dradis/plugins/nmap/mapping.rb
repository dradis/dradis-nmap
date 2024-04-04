module Dradis::Plugins::Nmap
  module Mapping
    DEFAULT_MAPPING = {
      host: {
        'Title' => 'Nmap info: {{ nmap[host.ip] }}',
        'IP' => '{{ nmap[host.ip] }}',
        'Hostnames' => '{{ nmap[host.hostnames] }}',
        'OS' => '{{ nmap[host.os] }}',
        'Services' => "|_. Port number |_. Protocol |_. State |_. Service |_. Product |_. Version |\n
                      {{ nmap[host.service_table] }}",
        'Type' => 'Properties'
      },
      port: {
        'Title' => '{{ nmap[port.number] }}/{{ nmap[port.protocol] }} is {{ nmap[port.state] }} ({{ nmap[port.reason] }})',
        'Service' => '{{ nmap[port.service.name] }}',
        'Product' => '{{ nmap[port.service.product] }}',
        'Version' => '{{ nmap[port.service.version] }}',
        'Host' => '{{ nmap[port.host] }}'
      }
    }.freeze

    SOURCE_FIELDS = {
      host: [
        'host.hostnames',
        'host.ip',
        'host.service_table',
        'host.os'
      ],
      port: [
        'port.number',
        'port.protocol',
        'port.state',
        'port.reason',
        'port.service.name',
        'port.service.product',
        'port.service.tunnel',
        'port.service.version',
        'port.host'
      ]
    }.freeze
  end
end
