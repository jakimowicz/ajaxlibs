$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ajaxlibs'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|  
end

Spec::Matchers.define :have_registered_child_class do |child_class|
  match do |base_class|
    base_class.class_eval("@@subclasses.keys.include?(:#{child_class})")
  end
end