module Ajaxlibs::IncludesHelper
  def ajaxlibs_include(*args)
    options = (Hash === args.last) ? args.pop : {}

    includes = args.collect {|library| javascript_include_library library, options}.join("\n")
      
    if options[:local] === false or options[:remote] === true or RAILS_ENV == 'production'
      <<-EOB
        <script type="text/javascript" src="#{Ajaxlibs::GoogleJSAPI}"></script>
        #{javascript_tag includes}
      EOB
    else
      includes
    end
  end
  
  def javascript_include_library(library, options)
    @included_javascript_libraries ||= {}
    
    # Check if required library exists
    raise Ajaxlibs::Exception::LibraryNotFound unless Ajaxlibs::Libraries.has_key?(library)
    
    # Set version if not set
    version = options.delete(:version) || Ajaxlibs::VersionsTools.max_version_for(library)

    # Check if required version exists for library
    raise Ajaxlibs::Exception::VersionNotFound unless Ajaxlibs::Libraries[library].has_key?(version)
    
    # Handle dependencies
    requirements = ''
    if Ajaxlibs::Libraries[library][version][:requires] and !@included_javascript_libraries.has_key?(Ajaxlibs::Libraries[library][version][:requires])
      requirements = javascript_include_library(Ajaxlibs::Libraries[library][version][:requires], options)
    end
      
    @included_javascript_libraries[library] = version
    
    # Javascript load code
    if (options[:local] === true or options[:remote] === false) or
        (options[:local].nil? and options[:remote].nil? and RAILS_ENV != 'production')
      "#{requirements}\n#{javascript_include_tag(ajaxlibs_local_path_for(library, version))}"
    else
      "#{requirements}\ngoogle.load('#{library}', '#{version}');"
    end
  end

  def ajaxlibs_local_path_for(library, version = nil)
    filename = Ajaxlibs::Libraries[library][version][:uncompressed] || library.to_s
    File.join('ajaxlibs', library.to_s, version, filename)
  end
end