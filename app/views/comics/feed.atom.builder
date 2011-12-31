atom_feed(:root_url => root_url) do |feed|
  feed.title("Comics")
  feed.updated(@strips.max_by{|s| s.date}.date)

  for strip in @strips
    feed.entry(strip) do |entry|
      entry.title("#{strip.comic.name} - #{strip.date}")
      entry.author strip.comic.name
      entry.content :type=>"xhtml" do |html|
        html.img :src=>root_url + strip.filepath, :alt=>strip.alt_tag, :title=>strip.title_tag
      end
    end
  end
end
