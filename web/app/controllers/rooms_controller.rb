class RoomsController < ApplicationController
  cattr_accessor  :last_update
  @@last_update = []
  # GET /rooms
  # GET /rooms.json
  def index
    @rooms = Room.all(:order => 'name')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @rooms }
      format.conf do
        data = @rooms.collect do |x|
          begin
            opt = eval("{#{x.room_type.options}}").merge(eval("{#{x.options}}"))
          rescue Exception => e
            opt = Hash.new
          end
          opt.merge! name: x.name.to_sym
          { klass: x.room_type.class_name.to_sym, options: opt }
        end
        send_data data.inspect
      end
    end
  end

  # GET /rooms/1
  # GET /rooms/1.json
  def show
    respond_to do |format|
      format.html { @room = Room.find(params[:id]) }
      format.js do
        if params[:time].to_i < @@last_update[params[:id].to_i].to_i
          @room = Room.find(params[:id])
        else
          render nothing: true
        end
      end
    end
  end

  # GET /rooms/new
  # GET /rooms/new.json
  def new
    @room = Room.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @room }
    end
  end

  # GET /rooms/1/edit
  def edit
    @room = Room.find(params[:id])
  end

  # POST /rooms
  # POST /rooms.json
  def create
    @room = Room.new(params[:room])

    respond_to do |format|
      if @room.save
        format.html { redirect_to rooms_url, notice: "[#{@room.name}] => #{t('c.created')}" }
        format.json { render json: @room, status: :created, location: @room }
      else
        format.html { render action: "new" }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /rooms/1
  # PUT /rooms/1.json
  def update
    @room = Room.find(params[:id])

    respond_to do |format|
      if @room.update_attributes(params[:room])
        format.html { redirect_to rooms_url, notice: "[#{@room.name}] => #{t('c.updated')}" }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rooms/1
  # DELETE /rooms/1.json
  def destroy
    @room = Room.find(params[:id])
    if @room.destroy
      respond_to do |format|
        format.html { redirect_to rooms_url, notice: "[#{@room.name}] => #{t('c.deleted')}" }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to rooms_url, alert: "[#{@room.name}] => #{t('c.cant_delete')}" }
        format.json { head :no_content }
      end
    end
  end
  
  def command
    @room = Room.find(params[:id])
    respond_to { |format| format.js }
    Domo.gds_req request: :eval, object: @room.name, expression: params[:options]
  end
end