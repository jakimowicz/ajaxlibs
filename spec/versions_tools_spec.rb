require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Ajaxlibs::VersionTools" do
  it "should accept equity" do
    Ajaxlibs::VersionsTools.compare('2.52.6', '2.52.6').should == 0
  end
  
  it "should handle major version difference" do
    Ajaxlibs::VersionsTools.compare('3',   '2'    ).should == 1
    Ajaxlibs::VersionsTools.compare('3.4', '2.4'  ).should == 1
    Ajaxlibs::VersionsTools.compare('3.4', '2.4.5').should == 1

    Ajaxlibs::VersionsTools.compare('2',     '3'    ).should == -1
    Ajaxlibs::VersionsTools.compare('2.4',   '3.4'  ).should == -1
    Ajaxlibs::VersionsTools.compare('2.4.5', '3.4.5').should == -1
  end
  
  it "should handle minor version difference" do
    Ajaxlibs::VersionsTools.compare('3.4', '3.1'  ).should == 1
    Ajaxlibs::VersionsTools.compare('3.4', '3.24' ).should == 1
    Ajaxlibs::VersionsTools.compare('3.4', '3.3.5').should == 1

    Ajaxlibs::VersionsTools.compare('3.1',   '3.4').should == -1
    Ajaxlibs::VersionsTools.compare('3.24',  '3.4').should == -1
    Ajaxlibs::VersionsTools.compare('3.3.5', '3.4').should == -1
  end
end