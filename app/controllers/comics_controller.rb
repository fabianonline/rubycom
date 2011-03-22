class ComicsController < ApplicationController
  def index
    @comics = Comic.all(:order=>"enabled DESC, name", :include=>:strips)
  end

  def show
    redirect_to :page=>1 unless params[:page]
    @comic = Comic.find(params[:id])
    @strips = Strip.paginate_by_comic_id @comic.id, :page=>params[:page], :order=>"date DESC", :per_page=>25
  end

  def day
    unless params[:id]
      date = Time.now.hour>=12 ? Date.today : Date.yesterday
      redirect_to :id=>date and return
    end
    @date = Date.parse(params[:id])
    @comics = Comic.enabled.all(:order=>:name)
  end

  def edit
    @comic = Comic.find(params[:id])
  end

  def debug
    @comic = Comic.find(params[:id])
  end

  def update
    @comic = Comic.find(params[:id])
    logger.debug("Comic: #{@comic.inspect}")
    logger.debug("Attributes: #{params[:comic].inspect}")
    if @comic.update_attributes(params[:comic])
      flash[:succes] = "Comic erfolgreich geändert."
      redirect_to debug_comic_url(@comic)
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
      redirect_to debug_comic_url(@comic)
    else
      flash[:error] = @comic.errors
      render :action=>:edit
    end
  end
end
