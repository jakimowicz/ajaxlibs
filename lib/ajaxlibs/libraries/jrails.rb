class Ajaxlibs::Library::Jrails < Ajaxlibs::Library
  Versions = ['0.5.0']

  Requirements = {:all => {:jqueryui => nil}}

  def local_only?
    true
  end
end