class Comic < ActiveRecord::Base
  has_many :strips, :order=>:date, :dependent=>:destroy
  named_scope :enabled, :conditions=>{:enabled=>true}

  def self.update_all
    Comic.enabled.each {|comic| comic.get_new_strip}
  end

  def get_img_element
    require 'open-uri'
    doc = Nokogiri::HTML(open(base_url))
    doc.css(search_query).first
  end

  def get_image_data(url)
    require 'net/http'
    req = Net::HTTP::Get.new(url.path)
    req.add_field("Referrer", base_url)
    res = Net::HTTP.new(url.host, url.port).start do |http|
      http.request(req)
    end

    raise "Body length is 0" unless res.body.length>0
    raise "HTTP-Error: #{res.code} - #{res.message}" unless res.code=="200"
    logger.debug(res.to_hash.inspect)
    return {:data=>res.body, :content_type=>res["content-type"]}
  end

  def calculate_hash_value(data)
    require 'digest/md5'
    Digest::MD5.hexdigest(data)
  end

  def image_data_known?(hash, bytes)
    return self.strips.find_by_hash_value_and_bytes(hash, bytes)!=nil
  end

  def save_image_data(data, url)
    require 'digest/md5'
    dir = RAILS_ROOT + "/public/comics/" + directory + "/"
    file = Time.now.strftime("%Y%m%d-%H%M%S") + File.extname(url.path)
    FileUtils.mkdir_p(dir)
    File.open(dir + file, 'w') {|f| f.write(data)}
    return file
  end

  def create_strip(filename, element, url, hash, length)
    strip = Strip.new
    strip.title_tag = element["title"] || ""
    strip.alt_tag = element["alt"] || ""
    strip.filename = filename
    strip.url = url.to_s
    strip.date = DateTime.now
    strip.bytes = length
    strip.comic = self
    strip.hash_value = hash
    strip.save
  end

  def get_url(element)
    URI.join(base_url, element["src"]) rescue nil
  end

  def get_new_strip
    print "Updating #{name}."
    element = get_img_element
    raise "Selektiertes Element ist kein img-Element" unless element.name=="img"
    url = get_url(element)
    data = get_image_data(url)[:data]
    hash = calculate_hash_value(data)
    length = data.length
    unless image_data_known? hash, length
      filename = save_image_data(data, url)
      create_strip(filename, element, url, hash, length)
      puts "Done."
    else
      puts "Known."
    end
  end
end
