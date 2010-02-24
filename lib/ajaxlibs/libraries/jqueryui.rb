class Ajaxlibs::Library::Jqueryui < Ajaxlibs::Library
  Versions = ['1.5.2',
              '1.5.3',
              '1.6'  ,
              '1.7.0',
              '1.7.1',
              '1.7.2']

  def requires #:nodoc:
    'jquery'
  end
  
  def filename #:nodoc:
    "jquery-ui"
  end
end