class Comic < ActiveRecord::Base
  has_many :strips, :order=>:date

  def self.update_all
    Comic.find(:all, :conditions=>{:enabled=>true}).each {|comic| comic.update}
  end

  def update
    require 'open-uri'
    require 'net/http'
    require 'digest/md5'
    puts "Hole base_url (#{base_url})..."
    doc = Nokogiri::HTML(open(base_url))
    puts "Suche..."
    element = doc.css(search_query).first
    raise unless element.name=="img"
    strip = Strip.new
    strip.title_tag = element["title"] || ""
    strip.alt_tag = element["alt"] || ""
    puts "Gefunden. src: #{element["src"]}"
    url = URI.join(base_url, element["src"])

    puts "Lade Bild..."
    req = Net::HTTP::Get.new(url.path)
    req.add_field("Referrer", base_url)
    res = Net::HTTP.new(url.host, url.port).start do |http|
      http.request(req)
    end

    raise unless res.body.length>0
    
    dir = RAILS_ROOT + "/public/comics/" + name + "/"
    file = Time.now.strftime("%Y%m%d-%H%M%S") + File.extname(url.path)

    FileUtils.mkdir_p(dir)
    File.open(dir + file, 'w') {|f| f.write(res.body)}

    strip.filename = file
    strip.url = url.to_s
    strip.date = DateTime.now
    strip.bytes = res.body.length
    strip.comic = self
    strip.hash_value = Digest::MD5.hexdigest(res.body)
    puts "Fertig. #{strip.inspect}"
    strip.save
  end

end
