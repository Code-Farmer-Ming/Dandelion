class User < ActiveRecord::Base
  #1000米
  DISTANCE=0.1000
  PAGE_SIZE=20
  validates_uniqueness_of     :email, :message=>"邮件已被注册"
   
  has_attached_file :photo ,
    :url  => "/assets/users/:id/:style/:id.:extension",
    :path => ":rails_root/public/assets/users/:id/:style/:id.:extension",
    :default_url=>""

  #是否注册完成
  attr_accessor :is_reg_finished
  attr_accessor :action
  
  def after_initialize 
    @action = 'Add'
  end
  
  #状态 
  STATUS={:reg_step_1=>'reg_step_1',:reg_finished=>'reg_finished'}
  has_many :msg_queues

  #已经 获取的消息
  has_many :catch_msgs,:through=>:msg_queues,:source=>:message
  
  has_many  :around_mes,:foreign_key=>"my_id"
  
  #四周的人
  has_many :around_me_users,:through=>:around_mes,:source=>:user
  
  def is_reg_finished
    self.status == STATUS[:reg_finished]
  end
  
  def photo_url
    url = photo.url()
    if Rails.env.production?
      url.blank? ? url : "http://www.beijuyo.com#{url}"
    else
      url.blank? ? url : "http://10.0.2.2:3000#{url}"
    end
  end
  
  def is_reg_finished=value
    self.status = STATUS[:reg_finished] if value
  end
  
  #判断用户名、密码是否正确 ，正确时返回 用户对象，否则-1 “邮件不存在” -2 “密码错误”
  def  self.login?(email,password)
    user = User.find_by_email(email)
    user ? ((user.password==password) ? user :-2) : -1
  end
  
  #周围的人更新队列 包含新加入的人和已经离开的人
  def around_me_update_queue
    new_around_me_users() +left_users()
  end
  
  #获取消息 包新的和要删除的
  def  get_msgs(page=1)
    uncatch_msgs = get_uncatch_msgs(page)
    del_msgs = get_useless_msgs()
    if page>1
      uncatch_msgs.each { |e| e.action='Insert'  }
    end
    catch_msgs << uncatch_msgs
    catch_msgs.delete(del_msgs)
    uncatch_msgs+del_msgs
  end
  
  #上线
  def online()
    update_attribute(:is_online,true)
  end
  
  #下线
  def offline()
    update_attribute(:is_online,false)
    around_me_users.delete_all()
    catch_msgs.delete_all()
  end
  
  private
  #新进入的周围的人
  def new_around_me_users()
    sql =<<SQL
     select a.*  from users a left join around_mes b on  a.id=b.user_id and b.my_id=#{id}  
     where b.id is null and a.id<>#{id} and  MyDistance(#{last_position_x},#{last_position_y},a.last_position_x,a.last_position_y)<#{DISTANCE}
     and a.is_online=true
SQL
    users = User.find_by_sql(sql)
    around_me_users << users
    users
  end
  
  #离开的周围的人
  def left_users()
    sql =<<SQL
     select b.user_id id , ''  email, 0 last_position_x, 0 last_position_y,photo_file_name
     from users a right join  around_mes b on  a.id=b.user_id
      and  MyDistance(#{last_position_x},#{last_position_y},a.last_position_x,a.last_position_y)<#{DISTANCE}
     where a.id is null  and b.my_id=#{id}
SQL
    left_users = User.find_by_sql(sql)
    around_me_users.delete(left_users)
    left_users.each { |e| e.action='Del'  }
  end
  
 
  # 根据坐标 获取 消息
  def get_uncatch_msgs(page=1)
    #需要添加 进去的消息
    sql =<<SQL
     select a.*  from messages a left join msg_queues b on  a.id=b.message_id and b.user_id=#{id}
     where b.id is null and  MyDistance(#{last_position_x},#{last_position_y},a.position_x,a.position_y)<#{DISTANCE}
     order by a.created_at
     limit #{page-1 * PAGE_SIZE},#{PAGE_SIZE}
SQL
    Message.find_by_sql(sql)
 
  end
  #需要删除的信息
  def get_useless_msgs()
    
    sql =<<SQL
     select b.message_id id ,0 user_id, ''  content, 0 position_x, 0 position_y
     from messages a right join msg_queues b on  a.id=b.message_id
      and  MyDistance(#{last_position_x},#{last_position_y},a.position_x,a.position_y)<#{DISTANCE}
      
     where a.id is null  and b.user_id=#{id}
SQL
    del_msgs = Message.find_by_sql(sql)
    del_msgs.each { |e| e.action='Del'  }
  end
  
 
end
