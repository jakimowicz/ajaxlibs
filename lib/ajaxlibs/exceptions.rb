# Global Ajaxlibs exception
class Ajaxlibs::Exception < StandardError
end

# LibraryNotFound exception, raised if library was not found
class Ajaxlibs::Exception::LibraryNotFound < Ajaxlibs::Exception
  
end

# VersionNotFound exception, raised if particular version of a library was not found
class Ajaxlibs::Exception::VersionNotFound < Ajaxlibs::Exception
end