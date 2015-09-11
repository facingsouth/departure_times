class SearchesController < ApplicationController

  def new
    # @ip = "72.229.28.185"
    # @ip = "67.160.204.113" #request.remote_ip
    request.remote_ip
    ip = request.env["HTTP_X_FORWARDED_FOR"]
    geo_response = Geocoder.search(ip)
    unless geo_response.empty?
      geo_response = geo_response[0].data 
      coord = "#{geo_response["latitude"]}, #{geo_response["longitude"]}"
      @addr = Geocoder.search(coord)[0].data["formatted_address"]
    end
    @search = Search.new(origin: @addr)
  end

  def create
    @search = Search.new(search_params)
    if @search.save
      redirect_to @search
    else
      flash[:error] = "Invalid search."
      render :new
    end
  end

  def show
    @search = Search.find(params[:id])
    @result = @search.search_result
  end

  private

  def search_params
    params.require(:search).permit(:origin, :destination)
  end
end
