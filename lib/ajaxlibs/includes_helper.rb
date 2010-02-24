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
    @included_javascript_libraries ||= []
    
    version = options.delete(:version)
    ajaxlib = Ajaxlibs::Library.by_name(library)
    
    result = []
    
    # Handle dependencies between libraries
    if ajaxlib.requires and !@included_javascript_libraries.include?(ajaxlib.requires)
      result << javascript_include_library(ajaxlib.requires, options)
    end
          
    @included_javascript_libraries << library
    
    # Javascript load code
    if (options[:local] === true or options[:remote] === false) or
        (options[:local].nil? and options[:remote].nil? and RAILS_ENV != 'production')
      result << javascript_include_tag(ajaxlib.local_path(version))
    else
      result << ajaxlib.google_cdn_load_code(version)
    end
    
    result.join("\n")
  end
end