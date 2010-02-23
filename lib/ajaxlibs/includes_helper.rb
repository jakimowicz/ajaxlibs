module Ajaxlibs::IncludesHelper
  def ajaxlibs_include(*args)
    options = (Hash === args.last) ? args.pop : {}

    includes = args.collect {|library| Ajaxlibs::Javascript.include_library library, options}.join("\n")
      
    if options[:local] === false or options[:remote] === true or RAILS_ENV == 'production'
      <<-EOB
        <script type="text/javascript" src="#{Ajaxlibs::GoogleJSAPI}"></script>
        #{javascript_tag includes}
      EOB
    else
      includes
    end
  end
  
end