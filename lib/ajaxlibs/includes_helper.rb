module Ajaxlibs::IncludesHelper
  # Returns an html script tag for each javascript library name provided.
  # By default, javascript files are loaded locally for development and test environment,
  # and through Google CDN on production environment. Basic dependencies are automatically handled.
  #
  # == Options
  # * <tt>version</tt> : specify the version to use for each library
  # * <tt>local</tt> : if true, always serve file locally, if false, use Google CDN
  # * <tt>remote</tt> : if false, always serve file locally, if true, use Google CDN
  #
  # == Exceptions
  # * <tt>Ajaxlibs::Exception::LibraryNotFound</tt> : raised if one or more of the given library is not available
  # * <tt>Ajaxlibs::Exception::VersionNotFound</tt> : raised if given version is not available for this/these library/libraries
  #
  # == Examples
  # * Simple library load, under the development environment
  #  ajaxlibs_include :jquery
  #    <script src="/javascripts/ajaxlibs/jquery/1.4.2/jquery.js?1267013480" type="text/javascript"></script>
  #
  #  ajaxlibs_include :jquery, :jqueryui
  #    <script src="/javascripts/ajaxlibs/jquery/1.4.2/jquery.js?1267013480" type="text/javascript"></script> 
  #    <script src="/javascripts/ajaxlibs/jqueryui/1.7.2/jqueryui.js?1267013480" type="text/javascript"></script>
  #
  # * Same examples as above, this time in production
  #  ajaxlibs_include :jquery
  #    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.js" type="text/javascript"></script>
  #
  #  ajaxlibs_include :jquery, :jqueryui
  #    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.js" type="text/javascript"></script>
  #    <script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.7.2/jquery-ui.js" type="text/javascript"></script>
  #
  # * Specifying version
  #  ajaxlibs_include :prototype, :version => '1.6.0.3'
  #    <script src="/javascripts/ajaxlibs/prototype/1.6.0.3/prototype.js?1267013480" type="text/javascript"></script>
  #
  # * Automatic dependencies
  #  ajaxlibs_include :scriptaculous
  #    <script src="/javascripts/ajaxlibs/prototype/1.6.1.0/prototype.js?1267013480" type="text/javascript"></script> 
  #    <script src="/javascripts/ajaxlibs/scriptaculous/1.8.3/scriptaculous.js?1267013481" type="text/javascript"></script>
  #
  def ajaxlibs_include(*args)
    options = (Hash === args.last) ? args.pop : {}
    
    includes = args.collect {|library| javascript_include_library library, options}.flatten.compact
    
    includes.collect {|ajaxlib| javascript_include_tag ajaxlib.include_path}.join("\n")
  end
  
  private
  def javascript_include_library(library, options)
    library = library.to_sym
    version = options.delete(:version)
    source  = (options[:local] === true or RAILS_ENV != 'production') ? :local : :remote
    ajaxlib = Ajaxlibs::Library.by_name(library, :version => version, :source => source)

    @included_javascript_libraries ||= []
    
    return if @included_javascript_libraries.include?(ajaxlib)
    @included_javascript_libraries << ajaxlib
    
    result = []
    
    ajaxlib.requires.each do |required_library, required_version|
      result << javascript_include_library(required_library, :version => required_version)
    end
    
    result << ajaxlib
  end
end