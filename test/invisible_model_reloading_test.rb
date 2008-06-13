require 'abstract_unit'
require 'pp'

class InvisibleModelReloadingTest < Test::Unit::TestCase

  def setup
    DrNicMagicModels.magic!
    create_fixtures :fun_users, :groups, :group_memberships, :group_tag, :adjectives, :adjectives_fun_users
  end
  
  def test_magic_can_be_stopped_and_started
    DrNicMagicModels.no_more_magic!
    assert !DrNicMagicModels.in_use
    DrNicMagicModels.magic!
    assert DrNicMagicModels.in_use
  end
  
  def test_magic_schema_clearing_works
    assert_not_nil Object.magic_schema
    assert_not_nil FunUser
    DrNicMagicModels.no_more_magic!
    Object.clear_magic_schema
    assert_nil Object.magic_schema
    assert_raise(NameError, "FunUser Is Still Defined") { FunUser }
    # DrNicMagicModels.magic!
  end
  
  def test_magic_schema_reloads
    assert_not_nil Group
    Object.clear_magic_schema
    assert_nil Object.magic_schema
    assert_not_nil Group
  end
  
end
