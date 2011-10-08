class ComicsController < ApplicationController
  def index
    @comics = Comic.all(:order=>"FIELD(status, 'errored', 'enabled', 'disabled'), error_count, name", :include=>:strips)
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
    @comics = Comic.enabled.all(:order=>:name, :include=>:strips).select{|c| c.strips.by_date(@date).count>0}
  end

  # Wird nur per AJAX aufgerufen.
  def get_new_strip
    comic = Comic.find(params[:id])
    result = {}
    begin
      if comic.get_new_strip
        result["new_comic"] = true
      else
        result["new_comic"] = false
      end
      result["success"] = true
    rescue => bang
      result["success"] = false
      result["error"] = bang.to_s
    end

    render :json=>result
  end

  def daylist
    @start = Strip.find(:first, :order=>:date).date.to_date rescue nil
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
    @all_results = @comic.get_new_strip(:debug=>true)
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

  def update_online_list
    begin
        comics = Comic.fetch_comic_list
    rescue Exception => ex
        flash[:error] = ex.to_s + ex.backtrace.join("<br>")
        return
    end
    @updateable_comics = []
    @new_comics = []

    comics.sort.each do |c|
      comic_details = c[1]
      comic_details["ident"] = c[0]
      comic = Comic.find_by_directory(c[0])
      if comic
        if comic_details.keys.any? {|key| key!="ident" && comic_details[key] != comic[key]}
          @updateable_comics << comic_details
        end
      else
        @new_comics << comic_details
      end
    end
  end

  def use_online_list
    comics = Comic.get_local_online_list
    params["comics"].each do |c|
      comic = Comic.find_or_initialize_by_directory(c)
      comic.update_attributes(comics[c])
      comic.save
    end
    redirect_to comics_url
  end

  def feed
    @strips = Comic.all(:order=>:name).collect{|c| c.strips.last(5)}.flatten
    respond_to do |format|
      format.atom
    end
  end
end
