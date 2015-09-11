class SearchesController < ApplicationController

  def new
    @search = Search.new
    # @ip = "67.160.204.113" #request.remote_ip
    request.remote_ip
    @ip = request.env["HTTP_X_FORWARDED_FOR"]
    @addr = Geocoder.search(@ip)
  end

  def create
    @search = Search.new(search_params)
    if @search.save
      redirect_to :show
    else
      flash[:error] = "Invalid search."
      render :new
    end
  end

  def show

  end

  private

  def search_params
    params.require(:search).permit(:origin, :destination)
  end
end
