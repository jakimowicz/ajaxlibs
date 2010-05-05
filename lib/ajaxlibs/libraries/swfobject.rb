class Ajaxlibs::Library::Swfobject < Ajaxlibs::Library
  Versions = ['2.1',
              '2.2']
  
  def file_name #:nodoc:
    @minified ? 'swfobject' : 'swfobject_src'
  end
end