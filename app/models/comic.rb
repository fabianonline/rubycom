class Comic < ActiveRecord::Base
  has_many :strips, :order=>:date, :dependent=>:destroy
  named_scope :enabled, :conditions=>{:enabled=>true}

  def self.update_all
    Comic.enabled.each {|comic| comic.get_new_strip}
  end

  def get_new_strip(do_save=true)
    require 'open-uri'
    require 'net/http'
    require 'digest/md5'
    print "Updating #{name}."
    print "Getting base_url (#{base_url})..."
    doc = Nokogiri::HTML(open(base_url))
    print "Parsing..."
    element = doc.css(search_query).first
    raise "Selektiertes Element ist kein img-Element." unless element.name=="img"
    print "Found."
    url = URI.join(base_url, element["src"])

    print "Loading image..."
    req = Net::HTTP::Get.new(url.path)
    req.add_field("Referrer", base_url)
    res = Net::HTTP.new(url.host, url.port).start do |http|
      http.request(req)
    end

    raise "Body length is 0" unless res.body.length>0

    hash = Digest::MD5.hexdigest(res.body)
    bytes = res.body.length

    # Falls der Comic schon existiert: Abbrechen
    if self.strips.find_by_hash_value_and_bytes hash, bytes
      puts "Already known."
      return
    end

    strip = Strip.new
    strip.title_tag = element["title"] || ""
    strip.alt_tag = element["alt"] || ""
    
    dir = RAILS_ROOT + "/public/comics/" + directory + "/"
    file = Time.now.strftime("%Y%m%d-%H%M%S") + File.extname(url.path)

    FileUtils.mkdir_p(dir)
    File.open(dir + file, 'w') {|f| f.write(res.body)}

    strip.filename = file
    strip.url = url.to_s
    strip.date = DateTime.now
    strip.bytes = res.body.length
    strip.comic = self
    strip.hash_value = Digest::MD5.hexdigest(res.body)
    puts "Done."
    strip.save if do_save
    return strip
  end

end
