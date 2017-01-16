class NmapTasks < Thor
  include Core::Pro::ProjectScopedTask if defined?(::Core::Pro)

  namespace "dradis:plugins:nmap"

  desc      "upload FILE", "upload the results of an Nmap scan"
  long_desc "Upload an Nmap scan to create nodes and notes for the hosts and "\
            "ports discovered during scanning."

  def upload(file_path)
    require 'config/environment'

    logger = Logger.new(STDOUT)
    logger.level = Logger::DEBUG

    unless File.exists?(file_path)
      $stderr.puts "** the file [#{file_path}] does not exist"
      exit(-1)
    end

    content_service = nil
    template_service = nil

    template_service = Dradis::Plugins::TemplateService.new(plugin: Dradis::Plugins::Nmap)
    if defined?(Dradis::Pro)
    # Set project scope from the PROJECT_ID env variable:
      detect_and_set_project_scope
      content_service = Dradis::Pro::Plugins::ContentService.new(plugin: Dradis::Plugins::Nmap)
    else
      content_service = Dradis::Plugins::ContentService.new(plugin: Dradis::Plugins::Nmap)
    end

    importer = Dradis::Plugins::Nmap::Importer.new(
                logger: logger,
       content_service: content_service, 
      template_service: template_service
    )
    
    importer.import(file: file_path)

    logger.close
  end
end
