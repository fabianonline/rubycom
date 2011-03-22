class ComicsController < ApplicationController
  def index
    @comics = Comic.all(:order=>"enabled DESC, name", :include=>:strips)
  end

  def list
    @comics = Comic.enabled.all(:order=>:name)
    @date = Date.today
  end

  def edit
    @comic = Comic.find(params[:id])
  end

  def update
    @comic = Comic.find(params[:id])
    logger.debug("Comic: #{@comic.inspect}")
    logger.debug("Attributes: #{params[:comic].inspect}")
    if @comic.update_attributes(params[:comic])
      flash[:succes] = "Comic erfolgreich geändert."
      redirect_to comics_url
    else
      flash[:error] = @comic.errors
      render :action=>:edit
    end
  end

  def new
    @comic = Comic.new
    render :action=>:edit
  end

  def create
    @comic = Comic.new(params[:comic])
    if @comic.save
      flash[:succes] = "Comic erfolgreich gespeichert."
      redirect_to comics_url
    else
      flash[:error] = @comic.errors
      render :action=>:edit
    end
  end
end
