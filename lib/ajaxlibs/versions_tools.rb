# Tools to manipulate versions strings (for example 1.2.3)
module Ajaxlibs::VersionsTools
  # Compare two versions and returns either :
  # * 1 if a > b
  # * 0 if a == b
  # * -1 if a < b
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