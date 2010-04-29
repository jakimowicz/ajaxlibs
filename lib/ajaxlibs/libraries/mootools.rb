class Ajaxlibs::Library::Mootools < Ajaxlibs::Library
  Versions = ["1.1.1",
              "1.1.2",
              "1.2.1",
              "1.2.2",
              "1.2.3",
              "1.2.4"]
  
  def file_name #:nodoc:
    @minified ? 'mootools-yui-compressed' : 'mootools'
  end
end