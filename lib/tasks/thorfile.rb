class NmapTasks < Thor
  include Rails.application.config.dradis.thor_helper_module

  namespace "dradis:plugins:nmap"

  desc      "upload FILE", "upload the results of an Nmap scan"
  long_desc "Upload an Nmap scan to create nodes and notes for the hosts and "\
            "ports discovered during scanning."
  method_option :state,
    type: :string,
    desc: 'The state your issues will be created with. If not provided, the scope will be draft'

  def upload(file_path)
    require 'config/environment'

    unless File.exists?(file_path)
      $stderr.puts "** the file [#{file_path}] does not exist"
      exit(-1)
    end

    detect_and_set_project_scope

    importer = Dradis::Plugins::Nmap::Importer.new(task_options)
    importer.import(file: file_path)
  end
end
