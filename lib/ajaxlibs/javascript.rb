module Ajaxlibs::Javascript
  def self.include_library(library, options)
    # Check if required library exists
    raise Ajaxlibs::Exception::LibraryNotFound unless Ajaxlibs::Libraries.has_key?(library)
    
    # Set version if not set
    version = options[:version] || Ajaxlibs::VersionsTools.max_version_for(library)

    # Check if required version exists for library
    raise Ajaxlibs::Exception::VersionNotFound unless Ajaxlibs::Libraries[library].has_key?(version)
    
    # Javascript load code
    if (options[:local] === true or options[:remote] === false) or
        (options[:local].nil? and options[:remote].nil? and RAILS_ENV != 'production')
      javascript_include_tag local_path_for(library, version)
    else
      "google.load('#{library}', '#{version}');"
    end
  end

  def self.local_path_for(library, version = nil)
    filename = Ajaxlibs::Libraries[library][version][:uncompressed] || library.to_s
    File.join('ajaxlibs', library.to_s, version, filename)
  end
end