require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "is reg finished" do
    user = User.create({:email=>"email@mail.com",:password=>"pass"})
    assert_equal false, user.is_reg_finished
    user.is_reg_finished=true
    user.update_attributes(:email=>'mod@mail.com')
    assert_equal true, user.is_reg_finished
  end
  
  
  test "login?" do
    assert  User.login?("one@mail.com",'one'),'登录失败'
    resut= User.login?("one@mail.com1",'one1')
    assert_equal -1, resut
    resut = User.login?("one@mail.com",'one1') 
    assert_equal -2, resut
  end
  
  test "new around me user" do
    assert_difference "users(:three).around_me_update_queue().size" do
      users(:one).update_attribute(:last_position_x,2)
      users(:one).update_attribute(:last_position_y,2)
    end
  end
  
  test "new around me user action add" do
    
    users(:one).update_attribute(:last_position_x,2)
    users(:one).update_attribute(:last_position_y,2)
    new_users = users(:three).around_me_update_queue() 
    new_users.each  do | user |
      assert_equal "Add", user.action
    end

  end
  
  test "level around me user" do
    users(:one).update_attribute(:last_position_x,2)
    users(:one).update_attribute(:last_position_y,2)
    assert_difference "users(:three).around_me_update_queue().size",0  do
      users(:three).update_attribute(:last_position_x,22)
      users(:three).update_attribute(:last_position_y,22)
    end
  end
  
  test "level around me user action del" do
    users(:one).update_attribute(:last_position_x,2)
    users(:one).update_attribute(:last_position_y,2)
    users(:three).around_me_update_queue().size 
    users(:three).update_attribute(:last_position_x,22)
    users(:three).update_attribute(:last_position_y,22)
    del_users = users(:three).around_me_update_queue() 
    del_users .each  do | user |
      assert_equal "Del", user.action
    end
  end
  
  test "get uncatch msg by xy" do
    msgs = users(:three).get_msgs()

    assert_equal(3,msgs.size)
    assert_equal 'Add',msgs.first.action
    assert_equal 'one',msgs.first.poster_name
  end
  

  test "get useless msg by xy" do
    user3 =users(:three)
    msgs = user3.get_msgs
    assert_equal 3,  msgs.size
    msgs =  user3.get_msgs()
    assert_equal(0,msgs.size)

    messages(:two).update_attribute("position_x",10)
    
 
    msgs =  user3.get_msgs
    assert_equal(1,msgs.size)
    assert_equal 'Del',msgs.first.action
    assert_equal 2,msgs.first.id
  
  end
  
end
