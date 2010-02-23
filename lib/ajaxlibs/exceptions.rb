class Ajaxlibs::Exception < StandardError
end

class Ajaxlibs::Exception::LibraryNotFound < Ajaxlibs::Exception
end

class Ajaxlibs::Exception::VersionNotFound < Ajaxlibs::Exception
end