require 'helper'

class Ajaxlibs::Library::Basic < Ajaxlibs::Library
  Versions = ['0.1',
              '1.4.9',
              '1.5',
              '1.8.1',
              '2.0.1.3']
end

class TestLibrary < Test::Unit::TestCase
  context "A library class" do
    should "returns library name based on its class name" do
      assert_equal 'basic', Ajaxlibs::Library::Basic.library_name
    end
  end
  
  context "A library instance" do
    setup do
      @library = Ajaxlibs::Library::Basic.new
    end

    should "returns latest version" do
      assert_equal '2.0.1.3', @library.latest_version
    end
    
    should "determine library_name by its own class name" do
      assert_equal 'basic', @library.library_name
    end
    
    should "use library_name as file_name by default" do
      assert_equal @library.library_name, @library.file_name
    end
    
    context "will return a local path composed of library_name, version and file_name" do
      should "using provided version if specified" do
        assert_equal "ajaxlibs/basic/1.8.1/basic", @library.local_path('1.8.1')
      end
      
      should "using latest version if none was specified" do
        assert_equal "ajaxlibs/basic/2.0.1.3/basic", @library.local_path
      end
      
      should "unless version was wrong" do
        assert_raises(Ajaxlibs::Exception::VersionNotFound) { @library.local_path('42') }
      end
    end

    context "will return a javascript code to load from google cdn with library_name and version" do
      should "using provided version if specified" do
        assert_equal "google.load('basic', '1.8.1');", @library.google_cdn_load_code('1.8.1')
      end
      
      should "using latest version if none was specified" do
        assert_equal "google.load('basic', '2.0.1.3');", @library.google_cdn_load_code
      end
      
      should "unless version was wrong" do
        assert_raises(Ajaxlibs::Exception::VersionNotFound) { @library.google_cdn_load_code('42') }
      end
    end
  end
  
  context "Base class" do
    should "returns the right instance while searching by name" do
      assert_kind_of Ajaxlibs::Library::Jquery, Ajaxlibs::Library.by_name(:jquery)
    end
    
    should "raise an exception if library is not found" do
      assert_raises(Ajaxlibs::Exception::LibraryNotFound) { Ajaxlibs::Library.by_name(:foo) }
    end
    
    should "register class by name when inherited" do
      assert_equal false, Ajaxlibs::Library.class_eval("@@subclasses.keys.include?(:foo)")
      class Ajaxlibs::Library::Foo < Ajaxlibs::Library
      end
      assert_equal true, Ajaxlibs::Library.class_eval("@@subclasses.keys.include?(:foo)")
      assert_equal Ajaxlibs::Library::Foo, Ajaxlibs::Library.class_eval("@@subclasses[:foo]")
    end
  end
end