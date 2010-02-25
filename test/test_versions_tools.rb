require 'helper'

class TestVersionTools < Test::Unit::TestCase
  should "accept equity" do
    assert_equal 0, Ajaxlibs::VersionsTools.compare('2.52.6', '2.52.6')
  end
  
  should "handle major version difference" do
    assert_equal 1, Ajaxlibs::VersionsTools.compare('3', '2')
    assert_equal 1, Ajaxlibs::VersionsTools.compare('3.4', '2.4')
    assert_equal 1, Ajaxlibs::VersionsTools.compare('3.4', '2.4.5')

    assert_equal -1, Ajaxlibs::VersionsTools.compare('2',     '3')
    assert_equal -1, Ajaxlibs::VersionsTools.compare('2.4',   '3.4')
    assert_equal -1, Ajaxlibs::VersionsTools.compare('2.4.5', '3.4.5')
  end
  
  should "handle minor version difference" do
    assert_equal 1, Ajaxlibs::VersionsTools.compare('3.4', '3.1')
    assert_equal 1, Ajaxlibs::VersionsTools.compare('3.4', '3.24')
    assert_equal 1, Ajaxlibs::VersionsTools.compare('3.4', '3.3.5')

    assert_equal -1, Ajaxlibs::VersionsTools.compare('3.1',   '3.4')
    assert_equal -1, Ajaxlibs::VersionsTools.compare('3.24',  '3.4')
    assert_equal -1, Ajaxlibs::VersionsTools.compare('3.3.5', '3.4')
  end
end
