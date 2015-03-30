class QuotesController < ApplicationController
  before_action :set_quote, only: [:show, :edit, :update, :destroy]

  def index
    @quotes = Quote.all

  end

  def show
    @quotes = Quote.find(params[:companyID])
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
    @quote.companyID = session[:current_company_id]
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
  #Need to consider moving this method to a seperate helper method location and giving it a message for :text based on where the request comes from (e.g. Companies Controller or Quotes Controller). Keeping here for the time being because this is possibly the only use for notifications
  def send_simple_message
      @emails = EmployeeEmail.all
      if @emails == []
        return
      else
      #rather unwise to have my api key just sitting here in the code, need to check if a new api-key can be generated
      RestClient.post "https://api:key-5f4ada711a8a86a1292bcfe23aa9d0aa"\
      "@api.mailgun.net/v2/sandbox3fcc0ad1e9ee457da78753f228405f7e.mailgun.org/messages",
      :from => "Excited User <mailgun@sandbox3fcc0ad1e9ee457da78753f228405f7e.mailgun.org>",
      :to => send_who_us,
      :subject => "Ovuline Notification Test",
      :text => "This is the Ovuline Notification System test message! #{@company.companyname} has submitted information to the Quotes Table! Is that former sentence incomplete or otherwise incorrect? Oh no! A bug!"
      end
  end
    
  def send_who_us
    @emails = EmployeeEmail.all
    @who_array = []
    @emails.each do |f|
        @who_array << f.email
    end
    @who=""
    @who_array.each do |f|
        @who << "#{f}"
        #need to break this down to test it piece by piece
        if f != @who_array[-1]
            @who << ", "
        end
    end
    #this method finishes with this return instead of an end, could cause trouble if @who is ever incorrect
    return @who

end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quote
      @quote = Quote.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def quote_params
      params[:quote].permit(:id, :adtype, :views, :demographics, :subtotal, :companyID)
    end
end
