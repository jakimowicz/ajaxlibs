class Ajaxlibs::Library::Jqueryui < Ajaxlibs::Library
  Versions = ['1.5.2',
              '1.5.3',
              '1.6'  ,
              '1.7.0',
              '1.7.1',
              '1.7.2',
              '1.8.0',
              '1.8.1']

  Requirements = {:all => {:jquery => nil}}

  def file_name #:nodoc:
    @minified ? 'jquery-ui.min' : 'jquery-ui'
  end
end