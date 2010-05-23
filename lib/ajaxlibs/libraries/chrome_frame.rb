class Ajaxlibs::Library::ChromeFrame < Ajaxlibs::Library
  Versions = ['1.0.0',
              '1.0.1',
              '1.0.2']

  def self.library_name #:nodoc:
      "chrome-frame"
  end

  def file_name #:nodoc:
    @minified ? 'CFInstall.min' : 'CFInstall'
  end
end
