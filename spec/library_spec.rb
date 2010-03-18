require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class Ajaxlibs::Library::Basic < Ajaxlibs::Library
  Versions = ['0.1',
              '1.4.9',
              '1.5',
              '1.8.1',
              '2.0.1.3']
  
  Requirements = {'1.5' => {:prototype => nil}, :all => {:scriptaculous => nil}}
end

describe "Ajaxlibs::Library" do
  context "class" do
    it "should returns library name based on its class name" do
      Ajaxlibs::Library::Basic.library_name.should == 'basic'
    end
  end
  
  context "instance" do
    before :each do
      @library = Ajaxlibs::Library::Basic.new
    end

    it "should returns latest version" do
      @library.latest_version.should == '2.0.1.3'
    end
    
    it "should use the latest version if non provided" do
      @library.version.should == @library.latest_version
    end
    
    it "should use a local source if non provided" do
      @library.source.should == :local
    end
    
    it "should determine library_name by its own class name" do
      @library.library_name.should == 'basic'
    end
    
    it "should use library_name as file_name by default" do
      @library.library_name.should == @library.file_name
    end
    
    it "should search through requirements using key :all if requirements for specific version is not found" do
      @library.requires.should == {:scriptaculous => nil}
    end
    
    it "should be equal to another library instance if class, version and source are equals" do
      another_library = Ajaxlibs::Library::Basic.new(:version => @library.version, :source => @library.source)
      @library.should == another_library
    end
    
    it "should not be equal to another library instance if source differs" do
      another_library = Ajaxlibs::Library::Basic.new(:version => @library.version, :source => :remote)
      @library.should_not == another_library
    end

    it "should not be equal to another library instance if version differs" do
      another_library = Ajaxlibs::Library::Basic.new(:version => '1.5', :source => @library.source)
      @library.should_not == another_library
    end

    it "should not be equal to another library instance if class differs" do
      class Ajaxlibs::Library::AnotherBasic < Ajaxlibs::Library::Basic
      end

      another_library = Ajaxlibs::Library::AnotherBasic.new(:version => @library.version, :source => @library.source)
      @library.should_not == another_library
    end

    example "should raise an error if provided version is wrong" do
      lambda { Ajaxlibs::Library::Basic.new(:version => '42') }.should raise_error(Ajaxlibs::Exception::VersionNotFound)
    end

    context "will return a local path composed of library_name, version and file_name" do
      example "using provided version if specified" do
        @library = Ajaxlibs::Library::Basic.new(:version => '1.8.1')
        @library.local_path.should == "ajaxlibs/basic/1.8.1/basic"
      end
      
      example "using latest version if none was specified" do
        @library.local_path.should == "ajaxlibs/basic/2.0.1.3/basic"
      end
      
      example "while calling include_path" do
        @library.include_path.should == @library.local_path
      end      
    end
    
    it "will return a local path if library is local only" do
      @library = Ajaxlibs::Library::Jrails.new
      @library.include_path.should == @library.local_path
    end
    
    it "will return a local path if library is local only even if asked for remote source" do
      @library = Ajaxlibs::Library::Jrails.new(:source => :remote)
      @library.include_path.should == @library.local_path
    end
    
    context "will return a javascript code to load from google cdn with library_name and version" do
      example "using provided version if specified" do
        @library = Ajaxlibs::Library::Basic.new(:version => '1.8.1')
        @library.google_cdn_include_path.should == "http://ajax.googleapis.com/ajax/libs/basic/1.8.1/basic.js"
      end
      
      example "using latest version if none was specified" do
        @library.google_cdn_include_path.should == "http://ajax.googleapis.com/ajax/libs/basic/2.0.1.3/basic.js"
      end      

      example "while calling include_path" do
        @library = Ajaxlibs::Library::Basic.new(:source => :remote)
        @library.include_path.should == @library.google_cdn_include_path
      end      
    end    
  end
  
  context "instance with version provided" do
    before :each do
      @library = Ajaxlibs::Library::Basic.new(:version => '1.5')
    end
    
    it "should returns provided version" do
      @library.version.should == '1.5'
    end
    
    it "should search through requirements using provided version" do
      @library.requires.should == {:prototype => nil}
    end
  end
  
  context "instance with source provided" do
    before :each do
      @library = Ajaxlibs::Library::Basic.new(:source => :remote)
    end
    
    it "should returns provided source" do
      @library.source.should == :remote
    end
  end
  
  context "base class" do
    example "will return the right instance while searching by name" do
      Ajaxlibs::Library.by_name(:jquery).should be_kind_of(Ajaxlibs::Library::Jquery)
    end
    
    example "will use given version" do
      Ajaxlibs::Library.by_name(:jquery, :version => '1.3.2').version.should == '1.3.2'
    end
    
    example "will use given source" do
      Ajaxlibs::Library.by_name(:jquery, :source => :remote).source.should == :remote
    end

    example "will raise an exception if library is not found" do
      lambda { Ajaxlibs::Library.by_name(:foo) }.should raise_error(Ajaxlibs::Exception::LibraryNotFound)
    end
    
    example "will raise an exception if version is not found" do
      lambda { Ajaxlibs::Library.by_name(:jquery, :version => '42') }.should raise_error(Ajaxlibs::Exception::VersionNotFound)
    end

    example "will register class by name when inherited" do
      Ajaxlibs::Library.should_not have_registered_child_class(:foo)
      lambda { Ajaxlibs::Library.by_name(:foo) }.should raise_error(Ajaxlibs::Exception::LibraryNotFound)
      class Ajaxlibs::Library::Foo < Ajaxlibs::Library
        Versions = %w{0}
      end
      Ajaxlibs::Library.should have_registered_child_class(:foo)
      Ajaxlibs::Library.all.should include(Ajaxlibs::Library::Foo)
      Ajaxlibs::Library.by_name(:foo).should be_kind_of(Ajaxlibs::Library::Foo)
    end
  end
  
end