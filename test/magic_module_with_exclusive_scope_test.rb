require 'abstract_unit'
require 'pp'

module MagicGroup
  magic_module :table_name_prefix => 'group_'
end

class MagicModuleWithExclusiveScopeTest < Test::Unit::TestCase

  def setup
    DrNicMagicModels.go_exclusive
  end
  
  def test_exclusive_scope_set
    assert DrNicMagicModels.exclusive_scopes?
  end
  
  def test_scopes_are_set
    assert_not_nil DrNicMagicModels.scopes
    assert DrNicMagicModels.scopes.include? MagicGroup
    assert !DrNicMagicModels.scopes.include?(Object)
  end
  
  def test_no_magic_schema_outside_scope
    assert_raise NameError do
      FunUser
    end
  end
  
  def test_magic_schema_inside_scope
    assert_not_nil MagicGroup::Membership
  end
  
end
