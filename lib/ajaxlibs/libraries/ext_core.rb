class Ajaxlibs::Library::ExtCore < Ajaxlibs::Library
  Versions = ["3.0.0",
              "3.1.0"]
  
  def self.library_name #:nodoc:
    "ext-core"
  end
  
  def file_name #:nodoc:
    @minified ? 'ext-core' : 'ext-core-debug'
  end
end