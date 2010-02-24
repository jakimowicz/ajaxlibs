require 'ajaxlibs/constants'
require 'ajaxlibs/exceptions'
require 'ajaxlibs/versions_tools'
require 'ajaxlibs/library'
require 'ajaxlibs/libraries/jquery'
require 'ajaxlibs/libraries/jqueryui'
require 'ajaxlibs/libraries/prototype'
require 'ajaxlibs/libraries/scriptaculous'
require 'ajaxlibs/includes_helper'

if Object.const_defined?(:ActionView)
  # Make Ajaxlibs helpers available in views
  ActionView::Base.send(:include, Ajaxlibs::IncludesHelper)

  # Copy all available js libraries to rails public folder
  if Object.const_defined?(:Rails) and File.directory?(File.join(Rails.root, 'public'))
    ajaxlibs_js_path = File.join(Rails.root, 'public', 'javascripts', 'ajaxlibs')
  
    # We do not have already copied local javascript files, copying them right away
    # OPTIMIZE : we should copy only necessary libraries
    unless File.directory?(ajaxlibs_js_path)
      FileUtils.mkdir_p(ajaxlibs_js_path)
      Ajaxlibs::Library.all.each do |library|
        library::Versions.each do |version|
          source      = File.join(File.dirname(__FILE__), '..', 'public', library.library_name, version, '*.*')
          destination = File.join(ajaxlibs_js_path, library.library_name, version)
          FileUtils.mkdir_p(destination)
          FileUtils.cp(Dir.glob(source), destination)
        end
      end
    end
  end
  
end