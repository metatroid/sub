class UploadsController < ApplicationController

	# GET /uploads
  # GET /uploads.xml
  def index
    @uploads = Upload.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @uploads }
    end
  end

  # GET /uploads/1
  # GET /uploads/1.xml
  def show
    @upload_audio = Upload.where(:id => params[:id]).where(:audio_file_name => "#{params[:file_name]}.#{params[:type]}") 
		@upload_video = Upload.where(:id => params[:id]).where(:video_file_name => "#{params[:file_name]}.#{params[:type]}")
		@user = current_user 
		if @user	
			@videos = @user.uploads.where("video_file_name IS NOT NULL")
			@audios = @user.uploads.where("audio_file_name IS NOT NULL")
			@images = @user.uploads.where("image_file_name IS NOT NULL")
			@archives = @user.uploads.where("archive_file_name IS NOT NULL")
		end
  end

  # GET /uploads/new
  # GET /uploads/new.xml
  def new
    @upload = Upload.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @upload }
    end
  end

  # GET /uploads/1/edit
  def edit
    @upload = Upload.find(params[:id])
  end

  # POST /uploads
  # POST /uploads.xml
  def create
    newparams = coerce(params)
		vparams = vcoerce(params)
		aparams = acoerce(params)
		iparams = icoerce(params)
		rparams = rcoerce(params)
    @upload = Upload.new(newparams[:upload]) unless params[:is_video] == '1' || params[:is_audio] == '1' || params[:is_image] == '1' || params[:is_archive] == '1'
		@upload = Upload.new(vparams[:upload]) if params[:is_video] == '1'
		@upload = Upload.new(aparams[:upload]) if params[:is_audio] == '1'
		@upload = Upload.new(iparams[:upload]) if params[:is_image] == '1'
		@upload = Upload.new(rparams[:upload]) if params[:is_archive] == '1'
    if @upload.save
      flash[:notice] = "attachment uploaded"
      respond_to do |format|
        format.html {redirect_to @upload.user}
        format.json {render :json => { :result => 'success', :upload => upload_path(@upload) } }
      end
    else
      render :action => 'new'
    end
  end
		
		

  # PUT /uploads/1
  # PUT /uploads/1.xml
  def update
    @upload = Upload.find(params[:id])

    respond_to do |format|
      if @upload.update_attributes(params[:upload])
        format.html { redirect_to(@upload, :notice => 'Upload was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @upload.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /uploads/1
  # DELETE /uploads/1.xml
  def destroy
    @upload = Upload.find(params[:id])
		if @upload.user_id == current_user.id
			@upload.destroy
		
			respond_to do |format|
				format.html { redirect_to(uploads_url) }
				format.xml  { head :ok }
			end
		end
	
  end
  
  private 
  def coerce(params)
    if params[:upload].nil? 
      h = Hash.new 
      h[:upload] = Hash.new 
      h[:upload][:user_id] = current_user.id 
      h[:upload][:photo] = params[:Filedata] 
      h[:upload][:photo].content_type = MIME::Types.type_for(h[:upload][:photo].original_filename).to_s
      h
    else 
      params
    end 
  end
  def vcoerce(params)
    if params[:upload].nil? 
      h = Hash.new 
      h[:upload] = Hash.new 
      h[:upload][:user_id] = current_user.id 
      h[:upload][:video] = params[:Filedata] 
      h[:upload][:video].content_type = MIME::Types.type_for(h[:upload][:video].original_filename).to_s
      h
    else 
      params
    end 
  end
	def acoerce(params)
    if params[:upload].nil? 
      h = Hash.new 
      h[:upload] = Hash.new 
      h[:upload][:user_id] = current_user.id 
      h[:upload][:audio] = params[:Filedata] 
      h[:upload][:audio].content_type = MIME::Types.type_for(h[:upload][:audio].original_filename).to_s
      h
    else 
      params
    end 
  end
	def icoerce(params)
    if params[:upload].nil? 
      h = Hash.new 
      h[:upload] = Hash.new 
      h[:upload][:user_id] = current_user.id 
      h[:upload][:image] = params[:Filedata] 
      h[:upload][:image].content_type = MIME::Types.type_for(h[:upload][:image].original_filename).to_s
      h
    else 
      params
    end 
  end
	def rcoerce(params)
    if params[:upload].nil? 
      h = Hash.new 
      h[:upload] = Hash.new 
      h[:upload][:user_id] = current_user.id 
      h[:upload][:archive] = params[:Filedata] 
      h[:upload][:archive].content_type = MIME::Types.type_for(h[:upload][:archive].original_filename).to_s
      h
    else 
      params
    end 
  end
end