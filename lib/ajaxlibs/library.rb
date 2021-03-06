require 'ajaxlibs/exceptions'
require 'ajaxlibs/versions_tools'

# Represents an ajaxlib library, regroups available version of a particular library
# and a few functions to generate either a filepath to local library or javascript loading code
# for Google CDN.
class Ajaxlibs::Library
  # Available versions for this library.
  Versions = []
  Requirements = {}
  
  attr_reader :version, :source, :secure
  
  @@subclasses = {}

  def self.inherited(child) #:nodoc:
    @@subclasses[child.library_name.to_sym] = child
  end
  
  # Returns all available libraries (instance of Ajaxlibs::Library).
  def self.all
    @@subclasses.values
  end
  
  # Search a specific library by its name (could be either a string or a symbol) and initialized it with given version and source.
  # See initialize method for available <tt>options</tt>.
  def self.by_name(name, options = {})
    @@subclasses[name.to_sym].new options
  rescue NoMethodError
    raise Ajaxlibs::Exception::LibraryNotFound
  end

  # Library name based on class name
  def self.library_name
    name.match(/::(\w+)$/)[1].downcase
  end
  
  # Initialize a new instance of a specific library.
  # <tt>options</tt> can take the following arguments :
  # * <tt>:version</tt> : specify a version (ex: "1.8.1").
  # * <tt>:source</tt> : force the source to use, default to <tt>:local</tt>.
  # * <tt>:secure</tt> : specify if the generated link should be secured (https) or not. Default is <tt>false</tt>.
  # * <tt>:minified</tt> : <tt>true</tt> if you want a minified version of the javascript library, <tt>false</tt> otherwise. Default is <tt>true</tt>.
  def initialize(options = {})
    @version  = check_version_or_latest_version(options[:version])
    @source   = options[:source] || :local
    @minified = options[:minified].nil? ? true : options[:minified]
    @secure   = options[:secure] || false
  end
  
  # Returns requirements for a library (for example, prototype for scriptaculous)
  def requires
    self.class::Requirements[@version] || self.class::Requirements[:all] || {}
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
  
  # Local path for a particular version, or the latest if given version is nil.
  # Search for the file in rails public path and copy it if needed.
  def local_path
    check_and_copy_local_file_to_rails_public
    File.join('ajaxlibs', library_name, version, file_name)
  end
  
  # Include path using google CDN
  def google_cdn_include_path
    scheme = secure ? "https" : "http"
    "#{scheme}://ajax.googleapis.com/ajax/libs/#{library_name}/#{version}/#{file_name}.js"
  end
  
  # Javascript include path regarding source (call either local_path or google_cdn_include_path)
  def include_path
    (source == :local or local_only?) ? local_path : google_cdn_include_path
  end
  
  def local_only?
    false
  end
  
  def ==(other)
    self.class == other.class and self.version == other.version and self.source == other.source
  end
  
  private
  # Checks if given version is available for this library,
  # raises Ajaxlibs::Exception::VersionNotFound if not and returns it.
  # Passing a nil value will returns the latest available version
  def check_version_or_latest_version(version = nil)
    version ||= latest_version
    raise Ajaxlibs::Exception::VersionNotFound unless self.class::Versions.include?(version)
    version
  end
  
  def check_and_copy_local_file_to_rails_public
    if Object.const_defined?(:Rails) and File.directory?(File.join(Rails.root, 'public'))

      ajaxlibs_js_path  = File.join(Rails.root, 'public', 'javascripts', 'ajaxlibs')
      source_path       = File.join(File.dirname(__FILE__), '../../public', library_name, version)
      source            = File.join(source_path, '*.*')
      destination       = File.join(ajaxlibs_js_path, library_name, version)
      
      if not File.exists?(destination) or Dir.entries(source_path) != Dir.entries(destination)
        FileUtils.mkdir_p(destination)
        FileUtils.cp(Dir.glob(source), destination)
      end

    end
  end
end