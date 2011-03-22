class Strip < ActiveRecord::Base
  belongs_to :comic
  named_scope :by_date, lambda {|date| 
    start = date.to_time - 12.hours;
    ende = start + 24.hours - 1;
    {:conditions=>["date>=? AND date<?", start, ende]}
  }

  def filepath
    File.join("/", "comics", comic.directory, filename)
  end

end
