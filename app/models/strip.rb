class Strip < ActiveRecord::Base
  belongs_to :comic

  def filepath
    File.join("/", "comics", comic.directory, filename)
  end

end
