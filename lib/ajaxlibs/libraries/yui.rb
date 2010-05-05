class Ajaxlibs::Library::YUI < Ajaxlibs::Library
  Versions = ['2.6.0',
              '2.7.0',
              '2.8.0r4']
  
  def google_cdn_include_path
    scheme = secure ? "https" : "http"
    "#{scheme}://ajax.googleapis.com/ajax/libs/yui/#{version}/build/yuiloader/#{file_name}.js"
  end

  def file_name #:nodoc:
    @minified ? 'yuiloader-min' : 'yuiloader'
  end
end