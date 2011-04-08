class ComicsController < ApplicationController
  def index
    @comics = Comic.all(:order=>"status, error_count DESC, name", :include=>:strips)
  end

  def show
    redirect_to :page=>1 unless params[:page]
    @comic = Comic.find(params[:id])
    @strips = Strip.paginate_by_comic_id @comic.id, :page=>params[:page], :order=>:date, :per_page=>25
  end

  def day
    unless params[:date] && params[:date]!="today"
      date = Time.now.hour>=12 ? Date.today : Date.yesterday
      redirect_to :date=>date and return
    end
    @date = Date.parse(params[:date])
    @comics = Comic.enabled.all(:order=>:name)
  end

  def daylist
    @start = Strip.find(:first, :order=>:date).date.to_date
    @end = (Time.now.hour>=12 ? Date.tomorrow : Date.today)
  end

  def destroy
    @comic = Comic.find(params[:id])
    unless @comic
      flash[:error] = "Invalid Comic-ID."
    else
      FileUtils.rm_r(@comic.image_path()) rescue ""
      @comic.destroy
      flash[:success] = "Erfolgreich gelöscht."
    end
    redirect_to comics_url
  end

  def edit
    @comic = Comic.find(params[:id])
  end

  def debug
    @comic = Comic.find(params[:id])
    @result = @comic.get_new_strip(:debug=>true)
  end

  def update
    @comic = Comic.find(params[:id])
    params[:comic][:error_count] = 0
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
