class Ajaxlibs::Library::Webfont < Ajaxlibs::Library
  Versions = ["1"]

  def file_name #:nodoc:
    @minified ? 'webfont' : 'webfont_debug'
  end
end
