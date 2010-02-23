module Ajaxlibs::IncludesHelper
  def ajaxlibs_include(*args)
    options = (Hash === args.last) ? args.pop : {}
    args.collect {|library| javascript_include_library library, options}
  end
  
  def javascript_include_library(library, options = {})
    if (options[:local] === true or options[:remote] === false) or
        (options[:local].nil? and options[:remote].nil? and RAILS_ENV != 'production')
      javascript_include_tag ajaxlibs_local_path_for(library, options[:version])
    else
      <<-EOL
        #{load_google_jsapi_once}
        <script>
          google.load("#{library}", "#{options[:version]}");
        </script>
      EOL
    end
  end
  
  def load_google_jsapi_once
    return "" if @google_jsapi_included
    @google_jsapi_included = true

    '<script src="http://www.google.com/jsapi"></script>'
  end
  
  def ajaxlibs_local_path_for(library, version = nil)
    version ||= AjaxLibs::VersionsTools.max(AjaxLibs::Libraries[library].keys)
    filename = Ajaxlibs::Libraries[library][version][:uncompressed] || library.to_s
    File.join('ajaxlibs', library.to_s, version, filename)
  end
end