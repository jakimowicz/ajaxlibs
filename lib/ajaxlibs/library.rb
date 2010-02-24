require 'ajaxlibs/exceptions'
require 'ajaxlibs/versions_tools'

class Ajaxlibs::Library
  Versions = []
  
  @@subclasses = {}

  def self.inherited(child)
    @@subclasses[child.library_name.to_sym] = child
  end
  
  def self.all
    @@subclasses.values
  end
  
  def self.by_name(name)
    @@subclasses[name.to_sym].new
  rescue NoMethodError
    raise Ajaxlibs::Exception::LibraryNotFound
  end

  def requires
    nil
  end
  
  def self.library_name
    name.match(/::(\w+)$/)[1].downcase
  end
  
  def library_name
    self.class.library_name
  end

  def file_name
    library_name
  end
  
  def latest_version
    self.class::Versions.max {|a, b| Ajaxlibs::VersionsTools.compare a, b}
  end
  
  def check_version_or_latest_version(version = nil)
    version ||= latest_version
    raise Ajaxlibs::Exception::VersionNotFound unless self.class::Versions.include?(version)
    version
  end
    
  def local_path(version = nil)
    File.join('ajaxlibs', library_name, check_version_or_latest_version(version), file_name)
  end
  
  def google_cdn_load_code(version = nil)
    "google.load('#{library_name}', '#{check_version_or_latest_version(version)}');"
  end
end