class UsersController < ApplicationController
  skip_before_filter :authentication_check ,:only=>[:create,:login,:new]
    
  # GET /users
  # GET /users.xml
  def index
    @users = current_user.around_me_update_queue()
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
      format.json { render  :json=> @users.to_json(:methods => [:action,:photo_url])}
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
     
    respond_to do |format|
      if @user.save
        format.html { redirect_to(@user, :notice => 'User was successfully created.') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
        format.json { render  :json=>@user.to_json(:methods => :is_reg_finished)}
      else
        format.html { render :action => "new" }
        format.json { render  :json=>@user.errors.to_json(), :status => :unprocessable_entity }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = current_user

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
        format.json { render :json=>@user.to_json(:methods => [:is_reg_finished,:photo_url])}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        format.json { render :json => @user.errors.to_json}
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
#    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
  
  def login
    if request.post?
      user =User.login?(params[:email],params[:password])
      if user==-1
        render :text=> "{""error"":""邮件未注册""}" 
      elsif user==-2
        render :text=> "{""error"":""密码错误""}" 
      else
        user.online
        render :json=> user.to_json(:methods => [:is_reg_finished ,:photo_url])
      end
    end
  end
  
  def logout
    current_user.offline
    render :nothing=>true
  end
end
