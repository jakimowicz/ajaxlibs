module Ajaxlibs::VersionsTools
  def self.max_version_for(library)
    Ajaxlibs::Libraries[library].keys.max {|a, b| Ajaxlibs::VersionsTools.compare a, b}
  end
  
  def self.compare(a, b)
    return 0 if a == b
    splitted_a, splitted_b = a.split('.'), b.split('.')
    splitted_a.each_with_index do |node, i|
      break if node < splitted_b[i]
      return 1 if node > splitted_b[i]
    end
    return -1
  end
end