class Ajaxlibs::Library::Jquery < Ajaxlibs::Library
  Versions = ['1.2.3',
              '1.2.6',
              '1.3.0',
              '1.3.1',
              '1.3.2',
              '1.4.0',
              '1.4.1',
              '1.4.2']
  
  def file_name #:nodoc:
    @minified ? 'jquery.min' : 'jquery'
  end
end