class QuotesController < ApplicationController
  before_action :set_quote, only: [:show, :edit, :update, :destroy]

  def index
    @quotes = Quote.all
  end

  def show
    @quote = Quote.find(params[:id])
  end

  def new
    @quotes = Quote.all
    @quote = Quote.new
  end

  def edit
    @quote = Quote.find(params[:id])
  end

  def create
    @quote = Quote.new(quote_params)

    if @quote.save
      flash[:notice] = 'Your quote information has been added'
      redirect_to new_quote_path
    else
      render action: 'new'
     end
  end

  def update
    @quote = Quote.find(params[:id])
    if @quote.update_attributes(quote_params)
      flash[:notice] = 'Your quote was updated'
      redirect_to new_quote_path
    else
      render action: 'new'
    end
  end

  def destroy
    @quote.destroy
    respond_to do |format|
      format.html { redirect_to new_quote_path, notice: 'Line-item was successfully removed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quote
      @quote = Quote.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def quote_params
      params[:quote].permit(:id, :adtype, :views, :demographics, :subtotal)
    end
end
