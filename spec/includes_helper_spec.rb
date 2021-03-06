require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Ajaxlibs::IncludesHelper" do
  before :all do
    class FakeActionView
      include Ajaxlibs::IncludesHelper
    end
  end
  
  before :each do
    @fake_action_view = FakeActionView.new
    @fake_action_view.stub! :javascript_include_tag
  end
  
  context "in development environment" do
    before :all do
      Object.send(:remove_const, 'RAILS_ENV') if Object.const_defined?('RAILS_ENV')
      RAILS_ENV = 'development'
    end
    
    it "should follow options to Ajaxlibs::Library class" do
      Ajaxlibs::Library.should_receive(:by_name).
                        with(:prototype, hash_including(:minified => false, :secure => true)).
                        once.
                        and_return(Ajaxlibs::Library::Prototype.new)
      
      @fake_action_view.ajaxlibs_include :prototype, :minified => false, :secure => true
    end

    context "should call javascript_include_tag to include local javascript library file" do
      example "once if only one library was specified" do
        @fake_action_view.should_receive(:javascript_include_tag).
                          with(Ajaxlibs::Library.by_name(:prototype).local_path).
                          once

        @fake_action_view.ajaxlibs_include :prototype
      end

      example "once for each specified library" do
        @fake_action_view.should_receive(:javascript_include_tag).
                          with(Ajaxlibs::Library.by_name(:prototype).local_path).
                          once
                          
        @fake_action_view.should_receive(:javascript_include_tag).
                          with(Ajaxlibs::Library.by_name(:scriptaculous).local_path).
                          once

        @fake_action_view.ajaxlibs_include :prototype, :scriptaculous
      end

      example "once for each specified library and dependendencies" do
        @fake_action_view.should_receive(:javascript_include_tag).
                          with(Ajaxlibs::Library.by_name(:prototype).local_path).
                          once
                          
        @fake_action_view.should_receive(:javascript_include_tag).
                          with(Ajaxlibs::Library.by_name(:scriptaculous).local_path).
                          once

        @fake_action_view.ajaxlibs_include :scriptaculous
      end
      
      example "once for specified library, avoiding multiple includes" do
        @fake_action_view.should_receive(:javascript_include_tag).
                          with(Ajaxlibs::Library.by_name(:prototype).local_path).
                          once
                          
        @fake_action_view.ajaxlibs_include :prototype, :prototype
      end      
      
      context "while specifying a specific version number" do
        example "once if one library was specified" do
          @fake_action_view.should_receive(:javascript_include_tag).
                            with(Ajaxlibs::Library.by_name(:prototype, :version => '1.6.0.3').local_path).
                            once

          @fake_action_view.ajaxlibs_include :prototype, :version => '1.6.0.3'
        end
      end # end of context "while specifying a specific version number"
      
      context "while asking for a uncompressed version" do
        example "with a filename to the uncompressed version" do
          @fake_action_view.should_receive(:javascript_include_tag).
                            with(Ajaxlibs::Library.by_name(:jquery, :minified => false).local_path).
                            once
          
          @fake_action_view.ajaxlibs_include :jquery, :minified => false
        end
      end # end of context "while asking for a uncompressed version"
      
      example "with a minified version by default" do
        @fake_action_view.should_receive(:javascript_include_tag).
                          with(Ajaxlibs::Library.by_name(:jquery, :minified => true).local_path).
                          once
        
        @fake_action_view.ajaxlibs_include :jquery
      end
      
    end # end of context "should call javascript_include_tag to include local javascript library file"
    
    example "should call javascript_include_tag with google cdn include path if specified source is remote" do
      @fake_action_view.should_receive(:javascript_include_tag).
                        with(Ajaxlibs::Library.by_name(:prototype).google_cdn_include_path).
                        once

      @fake_action_view.ajaxlibs_include :prototype, :local => false
    end
    
  end # end of context "in development environment"
  
  context "in production environment" do
    before :each do
      Object.send(:remove_const, 'RAILS_ENV') if Object.const_defined?('RAILS_ENV')
      RAILS_ENV = 'production'
    end

    context "should call javascript_include_tag with google cdn include path" do
      example "once if only one library was specified" do
        @fake_action_view.should_receive(:javascript_include_tag).
                          with(Ajaxlibs::Library.by_name(:prototype).google_cdn_include_path).
                          once

        @fake_action_view.ajaxlibs_include :prototype
      end

      example "on environments defined in ProductionEnvironments" do
        Ajaxlibs::ProductionEnvironments << 'fake_production_environment'
        Object.send(:remove_const, 'RAILS_ENV') if Object.const_defined?('RAILS_ENV')
        RAILS_ENV = 'fake_production_environment'
        @fake_action_view.should_receive(:javascript_include_tag).
                          with(Ajaxlibs::Library.by_name(:prototype).google_cdn_include_path).
                          once

        @fake_action_view.ajaxlibs_include :prototype
      end

      example "once for each specified library" do
        @fake_action_view.should_receive(:javascript_include_tag).
                          with(Ajaxlibs::Library.by_name(:prototype).google_cdn_include_path).once
        @fake_action_view.should_receive(:javascript_include_tag).
                          with(Ajaxlibs::Library.by_name(:scriptaculous).google_cdn_include_path).once
        @fake_action_view.ajaxlibs_include :prototype, :scriptaculous
      end

      example "once for each specified library and dependendencies" do
        @fake_action_view.should_receive(:javascript_include_tag).
                          with(Ajaxlibs::Library.by_name(:prototype).google_cdn_include_path).once
        @fake_action_view.should_receive(:javascript_include_tag).
                          with(Ajaxlibs::Library.by_name(:scriptaculous).google_cdn_include_path).once                                
        @fake_action_view.ajaxlibs_include :scriptaculous
      end
      
      example "once for specified library, avoiding multiple includes" do
        @fake_action_view.should_receive(:javascript_include_tag).
                          with(Ajaxlibs::Library.by_name(:prototype).google_cdn_include_path).
                          once
                          
        @fake_action_view.ajaxlibs_include :prototype, :prototype
      end
      
      example "using a secured connection if secured was specified" do
        @fake_action_view.should_receive(:javascript_include_tag).
                          with(Ajaxlibs::Library.by_name(:prototype, :secure => true).google_cdn_include_path).
                          once
                          
        @fake_action_view.ajaxlibs_include :prototype, :secure => true
      end
      
      context "while specifying a specific version number" do
        example "once if one library was specified" do
          @fake_action_view.should_receive(:javascript_include_tag).
                            with(Ajaxlibs::Library.by_name(:prototype, :version => '1.6.0.3').google_cdn_include_path).
                            once

          @fake_action_view.ajaxlibs_include :prototype, :version => '1.6.0.3'
        end
      end # end of context "while specifying a specific version number"
      
      context "while asking for a uncompressed version" do
        example "with a filename to the uncompressed version" do
          @fake_action_view.should_receive(:javascript_include_tag).
                            with(Ajaxlibs::Library.by_name(:jquery, :minified => false).google_cdn_include_path).
                            once
          
          @fake_action_view.ajaxlibs_include :jquery, :minified => false
        end
      end # end of context "while asking for a uncompressed version"
      
      example "with a minified version by default" do
        @fake_action_view.should_receive(:javascript_include_tag).
                          with(Ajaxlibs::Library.by_name(:jquery, :minified => true).google_cdn_include_path).
                          once
        
        @fake_action_view.ajaxlibs_include :jquery
      end
      
    end # end of context "should call javascript_include_tag with google cdn include path"
  end # end of context "in production environment"
end