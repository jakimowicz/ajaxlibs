require 'ajaxlibs/libraries'
require 'ajaxlibs/exceptions'
require 'ajaxlibs/versions_tools'
require 'ajaxlibs/includes_helper'

if Object.const_defined?(:Rails) and File.directory?(File.join(Rails.root, 'public'))
  ActionView::Base.send(:include, Ajaxlibs::IncludesHelper)

  ajaxlibs_js_path = File.join(Rails.root, 'public', 'javascripts', 'ajaxlibs')
  
  # We do not have already copied local javascript files, copying them right away
  unless File.directory?(ajaxlibs_js_path)
    FileUtils.mkdir_p(ajaxlibs_js_path)
    Ajaxlibs::Libraries.each do |library, versions|
      versions.each_key do |version|
        source      = File.join(File.dirname(__FILE__), '..', 'public', library.to_s, version, '*.*')
        destination = File.join(ajaxlibs_js_path, library.to_s, version)
        FileUtils.mkdir_p(destination)
        FileUtils.cp(Dir.glob(source), destination)
      end
    end
  end
end