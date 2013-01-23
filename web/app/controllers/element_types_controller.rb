class ElementTypesController < ApplicationController
  # GET /element_types
  # GET /element_types.json
  def index
    @element_types = ElementType.all(:order => 'name')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @element_types }
    end
  end

  # GET /element_types/1
  # GET /element_types/1.json
  def show
    @element_type = ElementType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @element_type }
    end
  end

  # GET /element_types/new
  # GET /element_types/new.json
  def new
    @element_type = ElementType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @element_type }
    end
  end

  # GET /element_types/1/edit
  def edit
    @element_type = ElementType.find(params[:id])
  end

  # POST /element_types
  # POST /element_types.json
  def create
    @element_type = ElementType.new(params[:element_type])

    respond_to do |format|
      if @element_type.save
        format.html { redirect_to element_types_url, notice: "[#{@element_type.name}] => #{t('c.created')}" }
        format.json { render json: @element_type, status: :created, location: @element_type }
      else
        format.html { render action: "new" }
        format.json { render json: @element_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /element_types/1
  # PUT /element_types/1.json
  def update
    @element_type = ElementType.find(params[:id])

    respond_to do |format|
      if @element_type.update_attributes(params[:element_type])
        format.html { redirect_to element_types_url, notice: "[#{@element_type.name}] => #{t('c.updated')}" }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @element_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /element_types/1
  # DELETE /element_types/1.json
  def destroy
    @element_type = ElementType.find(params[:id])
    if @element_type.destroy
      respond_to do |format|
        format.html { redirect_to element_types_url, notice: "[#{@element_type.name}] => #{t('c.deleted')}" }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to element_types_url, alert: "[#{@element_type.name}] => #{t('c.cant_delete')}" }
        format.json { head :no_content }
      end
    end
  end
end
