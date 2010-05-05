# JRails library, local support only.
# This is only the javascript support of JRails, you must install JRails plugin to have a full support.
class Ajaxlibs::Library::Jrails < Ajaxlibs::Library
  Versions = ['0.5.0']

  Requirements = {:all => {:jqueryui => nil}}

  def local_only?
    true
  end
  
  def initialize(options = {})
    require 'rubygems'
    require 'jrails' # Check if we have jrails support before trying to load it
    super
  rescue LoadError
    raise "jrails gem is missing, you must install it."
  end
end