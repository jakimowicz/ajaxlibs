class Ajaxlibs::Library::Dojo < Ajaxlibs::Library
  Versions = ["1.1.1",
              "1.2.0",
              "1.2.3",
              "1.3.0",
              "1.3.1",
              "1.3.2",
              "1.4.0",
              "1.4.1",
              "1.4.3"]
  
  def file_name #:nodoc:
    @minified ? 'dojo.xd' : 'dojo.xd.js.uncompressed'
  end
end