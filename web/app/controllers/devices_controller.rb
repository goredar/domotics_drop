class DevicesController < ApplicationController
  # GET /devices
  # GET /devices.json
  def index
    @devices = Device.all(:order => 'name')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @devices }
      format.conf do
        data = Hash.new
        @devices.each do |x|
          begin
            opt = eval("{#{x.device_type.options}}").merge(eval("{#{x.options}}"))
          rescue Exception => e
            opt = Hash.new
          end
          data[x.name.to_sym] = { class: x.device_type.class_name.to_sym, options: opt }
        end
        send_data Marshal.dump(data)
      end
    end
  end

  # GET /devices/1
  # GET /devices/1.json
  def show
    @device = Device.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @device }
    end
  end

  # GET /devices/new
  # GET /devices/new.json
  def new
    @device = Device.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @device }
    end
  end

  # GET /devices/1/edit
  def edit
    @device = Device.find(params[:id])
  end

  # POST /devices
  # POST /devices.json
  def create
    @device = Device.new(params[:device])

    respond_to do |format|
      if @device.save
        format.html { redirect_to devices_url, notice: "[#{@device.name}] => #{t('c.created')}" }
        format.json { render json: @device, status: :created, location: @device }
      else
        format.html { render action: "new" }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /devices/1
  # PUT /devices/1.json
  def update
    @device = Device.find(params[:id])

    respond_to do |format|
      if @device.update_attributes(params[:device])
        format.html { redirect_to devices_url, notice: "[#{@device.name}] => #{t('c.updated')}" }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /devices/1
  # DELETE /devices/1.json
  def destroy
    @device = Device.find(params[:id])
    if @device.destroy
      respond_to do |format|
        format.html { redirect_to devices_url, notice: "[#{@device.name}] => #{t('c.deleted')}" }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to devices_url, alert: "[#{@device.name}] => #{t('c.cant_delete')}" }
        format.json { head :no_content }
      end
    end
  end
end
