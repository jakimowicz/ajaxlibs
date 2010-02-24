require 'ajaxlibs/exceptions'
require 'ajaxlibs/versions_tools'

# Represents an ajaxlib library, regroups available version of a particular library
# and a few functions to generate either a filepath to local library or javascript loading code
# for Google CDN.
class Ajaxlibs::Library
  # Available versions for this library.
  Versions = []
  
  @@subclasses = {}

  def self.inherited(child) #:nodoc:
    @@subclasses[child.library_name.to_sym] = child
  end
  
  # Returns all available libraries (instance of Ajaxlibs::Library).
  def self.all
    @@subclasses.values
  end
  
  # Search a specific library by its name, could by either a string or a symbol.
  def self.by_name(name)
    @@subclasses[name.to_sym].new
  rescue NoMethodError
    raise Ajaxlibs::Exception::LibraryNotFound
  end

  # Library name based on class name
  def self.library_name
    name.match(/::(\w+)$/)[1].downcase
  end
  
  # Returns requirements for a library (for example, prototype for scriptaculous)
  def requires
    nil
  end
  
  # Library name based on class name
  def library_name
    self.class.library_name
  end

  # Javascript library filename, can be different from library_name (jqueryui / jquery-ui for example)
  def file_name
    library_name
  end
  
  # Search for the latest version available using given Versions
  def latest_version
    self.class::Versions.max {|a, b| Ajaxlibs::VersionsTools.compare a, b}
  end
  
  # Checks if given version is available for this library,
  # raises Ajaxlibs::Exception::VersionNotFound if not and returns it.
  # Passing a nil value will returns the latest available version
  def check_version_or_latest_version(version = nil)
    version ||= latest_version
    raise Ajaxlibs::Exception::VersionNotFound unless self.class::Versions.include?(version)
    version
  end
    
  # Local path for a particular version, or the latest if given version is nil.
  def local_path(version = nil)
    File.join('ajaxlibs', library_name, check_version_or_latest_version(version), file_name)
  end
  
  # Javascript load code through google jsapi for a particular version, or the latest if given version is nil.
  def google_cdn_load_code(version = nil)
    "google.load('#{library_name}', '#{check_version_or_latest_version(version)}');"
  end
end