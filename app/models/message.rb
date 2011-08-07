class Message < ActiveRecord::Base
  attr_accessor :action
  belongs_to :user

  def after_initialize
    @action = 'Add'
  end

  def poster_name
    user ? user.nick_name  : "未知"
  end
  
  def poster_img_url
    user ?  user.photo_url : ""
  end
end
