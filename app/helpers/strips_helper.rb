module StripsHelper
  def image_tag_for_strip(strip)
    image_tag strip.filepath, :alt=>strip.alt_tag, :title=>strip.title_tag
  end
end
