module Dradis::Plugins::Nmap
  class Importer < Dradis::Plugins::Upload::Importer
    # The framework will call this function if the user selects this plugin from
    # the dropdown list and uploads a file.
    # @returns true if the operation was successful, false otherwise
    def import(params={})
    end
  end
end
