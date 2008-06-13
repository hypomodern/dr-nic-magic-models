require File.dirname(__FILE__) + '/abstract_unit'

class InvisibleModelAssocTest < Test::Unit::TestCase
  # fixtures :fun_users, :groups, :group_memberships, :group_tag, :adjectives, :adjectives_fun_users
  
  def setup
    create_fixtures :fun_users, :groups, :group_memberships, :group_tag, :adjectives, :adjectives_fun_users
    @group = Group.find(1)
    @group_tag = GroupTag.find(1)
    @user = FunUser.find(1)
    @membership = GroupMembership.find(1)
  end
  
  def test_belongs_to
    assert_equal @user, @membership.fun_user
    assert_equal @group, @membership.group
    manual_result = GroupTag.find(:all, :conditions => ['group_tag.group_id = ?', @group.id]) #.sort{|a,b| a.id <=> b.id}
    auto_result = @group.group_tags #.sort{|a,b| a.id <=> b.id}
    
    # Attempting to debug random problems I have with the associations sometimes. On Wednesdays, this test fails because the association #group_tags
    # inexplicably uses referenced_group_id instead of group_id.
    # puts "***"
    # puts Group.reflections.values.first.options
    # puts "***"
    
    assert_equal manual_result, auto_result, "GroupTag.find(:all) with conditions != @group.group_tags"
      
  end
  
  def test_hatbm
    assert_equal([Adjective.find(1)], @user.adjectives)
  end
    
  def test_fk
    
    gt = GroupTag.find(1)

    # Not using FKs
    g = gt.group    
    assert g.class == Group
    assert g.id == 1
    
    # Using FKs
    if g.connection.supports_fetch_foreign_keys?
      g = gt.referenced_group    
      assert g.class == Group
      assert g.id == 1
    end
  end
  
  def test_has_many
    assert_equal [@membership], @group.group_memberships
    assert_equal @group, @membership.group
  end

  def test_has_one
    if @group_tag.connection.supports_fetch_foreign_keys?
      assert_equal @group, @group_tag.referenced_group
      # assert_equal @group_tag, @group.group_tag_as_referenced_group
    end
  end
  
  def test_indirect
    assert_equal [@user], @group.fun_users
    assert_equal [@group], @user.groups 
  end
end
