class ElementsController < ApplicationController
  # GET /elements
  # GET /elements.json
  def index
    @elements = Element.by_room
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @elements }
      format.conf do
        data = @elements.collect do |x|
          begin
            opt = eval("{#{x.element_type.options}}").merge(eval("{#{x.options}}"))
          rescue Exception => e
            opt = Hash.new
          end
          opt.merge! name: x.name.to_sym , room: x.room.name.to_sym, 
            device: x.device.name.to_sym, id: x.id, state: x.state
          { klass: x.element_type.class_name.to_sym, options: opt }
        end
        send_data data.inspect
      end
    end
  end

  # GET /elements/1
  # GET /elements/1.json
  def show
    @element = Element.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @element }
    end
  end

  # GET /elements/new
  # GET /elements/new.json
  def new
    @element = Element.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @element }
    end
  end

  # GET /elements/1/edit
  def edit
    @element = Element.find(params[:id])
  end

  # POST /elements
  # POST /elements.json
  def create
    @element = Element.new(params[:element])

    respond_to do |format|
      if @element.save
        format.html { redirect_to elements_url, notice: "[#{@element.name}] => "+t('c.created') }
        format.json { render json: @element, status: :created, location: @element }
      else
        format.html { render action: "new" }
        format.json { render json: @element.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /elements/1
  # PUT /elements/1.json
  def update
    @element = Element.find(params[:id])

    respond_to do |format|
      if @element.update_attributes(params[:element])
        format.html { redirect_to elements_url, notice: "[#{@element.name}] => "+t('c.updated') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @element.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /elements/1
  # DELETE /elements/1.json
  def destroy
    @element = Element.find(params[:id])
    if @element.destroy
      respond_to do |format|
        format.html { redirect_to elements_url, notice: "[#{@element.name}] => "+t('c.deleted') }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to elements_url, alert: "[#{@element.name}] => "+t('c.cant_delete') }
        format.json { head :no_content }
      end
    end
  end
  
  def command
    @element = Element.find(params[:id])
    @element.state = Domo.gds_req({ request: :eval, object: @element.room.name, expression: "#{@element.name}.#{params[:options]}" })[:reply]
    RoomsController.last_update[@element.room.id] = (Time.now.to_f*1000).to_i
    respond_to { |format| format.js }
  end

end