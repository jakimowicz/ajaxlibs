module Ajaxlibs::IncludesHelper
  def ajaxlibs_include(*args)
    options = (Hash === args.last) ? args.pop : {}

    includes = args.collect {|library| javascript_include_library library, options}.join('\n')
      
    if options[:local] === false or options[:remote] === true or RAILS_ENV == 'production'
      "#{load_google_jsapi_once}\n#{javascript_tag includes}"
    else
      includes
    end
  end
  
  def javascript_include_library(library, options)
    # Check if required library exists
    raise Ajaxlibs::Exception::LibraryNotFound unless Ajaxlibs::Libraries.has_key?(library)
    
    version = options[:version] || Ajaxlibs::VersionsTools.max_version_for(library)
    
    raise Ajaxlibs::Exception::VersionNotFound unless Ajaxlibs::Libraries[library].has_key?(version)
    
    if (options[:local] === true or options[:remote] === false) or
        (options[:local].nil? and options[:remote].nil? and RAILS_ENV != 'production')
      javascript_path ajaxlibs_local_path_for(library, version)
    else
      <<-EOB
        google.load("#{library}", "#{version}");
      EOB
    end
  end

  def load_google_jsapi_once
    return "" if @google_jsapi_included
    @google_jsapi_included = true

    '<script src="http://www.google.com/jsapi"></script>'
  end
  
  def ajaxlibs_local_path_for(library, version = nil)
    filename = Ajaxlibs::Libraries[library][version][:uncompressed] || library.to_s
    File.join('ajaxlibs', library.to_s, version, filename)
  end
end