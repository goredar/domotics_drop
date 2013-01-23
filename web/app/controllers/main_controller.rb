class MainController < ApplicationController
  @@term_output = Array.new
  def index
    @term_output = @@term_output
  end
  def post_terminal_line
    @@term_output << params[:terminal_line]
    render :nothing => true
  end
  def server_clear
    @@term_output.clear
    @term_output = @@term_output
    respond_to do |format|
      format.html { redirect_to :index }
      format.js { render 'server_terminal' }
    end
  end
  def server_refresh
    @term_output = @@term_output
    respond_to do |format|
      format.html { redirect_to :index }
      format.js { render 'server_terminal' }
    end
  end
end