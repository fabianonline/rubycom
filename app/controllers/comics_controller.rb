class ComicsController < ApplicationController
  def index
  end

  def show
    @comics = Comic.enabled.all(:order=>:name)
    @date = Date.today
  end

end
