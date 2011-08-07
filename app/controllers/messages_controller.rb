class MessagesController < ApplicationController
  # GET /messages
  # GET /messages.xml
  def index
    
#    uncatch_msgs = Message.get_uncatch_msgs(current_user)
#    current_user.catch_msgs << uncatch_msgs
#    useless_msgs = Message.get_useless_msgs(current_user)
#    
#    current_user.catch_msgs.delete(useless_msgs)
    @messages =  current_user.get_msgs

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @messages }
      format.json { render  :json=>@messages.to_json(:methods =>[:action ,:poster_name,:poster_img_url])}
    end
  end

  # GET /messages/1
  # GET /messages/1.xml
  def show
    @message = Message.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @message }
    end
  end

  # GET /messages/new
  # GET /messages/new.xml
  def new
    @message = Message.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @message }
    end
  end

  # GET /messages/1/edit
  def edit
    @message = Message.find(params[:id])
  end

  # POST /messages
  # POST /messages.xml
  def create
    @message = Message.new(params[:message])
    @message.user_id = current_user_id;
    @message.position_x = current_user.last_position_x
    @message.position_y = current_user.last_position_y
    current_user.catch_msgs << @message
    respond_to do |format|
      if @message.save
        format.html { redirect_to(@message, :notice => 'Message was successfully created.') }
        format.xml  { render :xml => @message, :status => :created, :location => @message }
        format.json { render  :json=>@message.to_json}
      else
        format.html { rend  er :action => "new" }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
        format.json { render :nothing=>true}
      end
    end
  end

  # PUT /messages/1
  # PUT /messages/1.xml
  def update
#    @message = Message.find(params[:id])

    respond_to do |format|
      if @message.update_attributes(params[:message])
        format.html { redirect_to(@message, :notice => 'Message was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.xml
  def destroy
    @message = Message.find(params[:id])
#    @message.destroy

    respond_to do |format|
      format.html { redirect_to(messages_url) }
      format.xml  { head :ok }
    end
  end
end
