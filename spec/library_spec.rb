require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class Ajaxlibs::Library::Basic < Ajaxlibs::Library
  Versions = ['0.1',
              '1.4.9',
              '1.5',
              '1.8.1',
              '2.0.1.3']
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
    
    it "should determine library_name by its own class name" do
      @library.library_name.should == 'basic'
    end
    
    it "should use library_name as file_name by default" do
      @library.library_name.should == @library.file_name
    end
    
    context "will return a local path composed of library_name, version and file_name" do
      example "using provided version if specified" do
        @library.local_path('1.8.1').should == "ajaxlibs/basic/1.8.1/basic"
      end
      
      example "using latest version if none was specified" do
        @library.local_path.should == "ajaxlibs/basic/2.0.1.3/basic"
      end
      
      example "unless version was wrong" do
        lambda { @library.local_path('42') }.should raise_error(Ajaxlibs::Exception::VersionNotFound)
      end
    end
    
    context "will return a javascript code to load from google cdn with library_name and version" do
      example "using provided version if specified" do
        @library.google_cdn_load_code('1.8.1').should == "google.load('basic', '1.8.1');"
      end
      
      example "using latest version if none was specified" do
        @library.google_cdn_load_code.should == "google.load('basic', '2.0.1.3');"
      end
      
      example "unless version was wrong" do
        lambda { @library.google_cdn_load_code('42') }.should raise_error(Ajaxlibs::Exception::VersionNotFound)
      end
    end    
  end
  
  context "base class" do
    example "will return the right instance while searching by name" do
      Ajaxlibs::Library.by_name(:jquery).should be_kind_of(Ajaxlibs::Library::Jquery)
    end

    example "will raise an exception if library is not found" do
      lambda { Ajaxlibs::Library.by_name(:foo) }.should raise_error(Ajaxlibs::Exception::LibraryNotFound)
    end

    example "will register class by name when inherited" do
      Ajaxlibs::Library.should_not have_registered_child_class(:foo)
      lambda { Ajaxlibs::Library.by_name(:foo) }.should raise_error(Ajaxlibs::Exception::LibraryNotFound)
      class Ajaxlibs::Library::Foo < Ajaxlibs::Library
      end
      Ajaxlibs::Library.should have_registered_child_class(:foo)
      Ajaxlibs::Library.all.should include(Ajaxlibs::Library::Foo)
      Ajaxlibs::Library.by_name(:foo).should be_kind_of(Ajaxlibs::Library::Foo)
    end
  end
  
end