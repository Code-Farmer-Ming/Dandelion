#消息队列 存放每个人的当前显示消息
class MsgQueue < ActiveRecord::Base
  belongs_to :message
  belongs_to :user
   
  #清除当前消息
  def self.clear_by_user(user_id)
    delete_all("user_id=#{user_id}")
  end
end
