# Tools to manipulate versions strings (for example 1.2.3)
module Ajaxlibs::VersionsTools
  # Compare two versions and returns either :
  # * 1 if a > b
  # * 0 if a == b
  # * -1 if a < b
  def self.compare(version_a, version_b)
    return 0 if version_a == version_b
    splitted_a, splitted_b = version_a.split('.'), version_b.split('.')
    splitted_a.each_with_index do |a_node, idx|
      b_node = splitted_b[idx]
      break if a_node < b_node
      return 1 if a_node > b_node
    end
    return -1
  end
end