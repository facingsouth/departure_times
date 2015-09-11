class SearchesController < ApplicationController

  def new
    @search = Search.new
    @ip = request.remote_ip
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
