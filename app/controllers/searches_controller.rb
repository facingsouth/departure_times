class SearchesController < ApplicationController

  def new
    # @ip = "72.229.28.185"
    # @ip = "67.160.204.113" #request.remote_ip
    addr = get_IP_location
    @search = Search.new(origin: addr)
  end

  def create
    @search = Search.new(search_params)
    if @search.save
      respond_to do |format|
        format.html { redirect_to @search }
        format.js { redirect_to @search }
      end
    else
      flash[:error] = "Invalid search."
      respond_to do |format|
        format.html { render :new }
        format.js { render :search_failure }
      end
    end
  end

  def show
    @search = Search.find(params[:id])
    @result = @search.search_result
    map = GoogleMap.new(@search.origin, @search.destination)
    @map_url = map.build_url
    respond_to do |format|
      format.html
      format.js { render :search_success }
    end
    
  end

  private

  def search_params
    params.require(:search).permit(:origin, :destination)
  end

  def get_IP_location
    request.remote_ip
    ip = request.env["HTTP_X_FORWARDED_FOR"]
    geo_response = Geocoder.search(ip)
    unless geo_response.empty?
      geo_response = geo_response[0].data 
      coord = "#{geo_response["latitude"]}, #{geo_response["longitude"]}"
      addr = Geocoder.search(coord)[0].data["formatted_address"]
    end
  end
end
