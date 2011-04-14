class Comic < ActiveRecord::Base
  has_many :strips, :order=>:date, :dependent=>:destroy
  named_scope :enabled, :conditions=>{:status=>"enabled"}

  validates_uniqueness_of :directory
  validates_length_of :directory, :minimum=>1

  def self.update_all
    STDOUT.sync = true
    errored_comics = []
    Comic.enabled.each do |comic|
      print "."
      begin
        comic.get_new_strip
      rescue => msg
        puts "Exception: #{msg}"
        temp = {}
        temp[:comic] = comic
        comic.last_error_message = msg.to_s
        temp[:message] = msg
        comic.last_error_at = Time.now
        comic.error_count += 1
        if comic.error_count>5
          comic.status = "errored"
          temp[:actions] = "Comic wurde deaktiviert!"
        else
          temp[:actions] = "Fehler ##{comic.error_count}. Nach 5 Fehlern wird der Comic deaktiviert."
        end
        errored_comics << temp if comic.error_count>1 # error_count wurde bereits erhöht - 1 bedeutet, dass der Comic das erste Mal Probleme macht. Dieses erste Mal ignorieren wir.
        comic.save
      else
        comic.error_count = 0
        comic.save
      end
    end

    unless errored_comics.empty?
      print "Es sind Fehler aufgetreten => verschicke Mail... "
      Notifications.deliver_errors(errored_comics) rescue nil
    end
    puts " Done."
  end

  def get_html
    require 'open-uri'
    html = ''
    open(base_url) do |f|
      html = f.read
    end
    return html
  end

  def get_img_element(html)
    doc = Nokogiri::HTML(html)
    doc.css(search_query).first
  end

  def get_image_data(url)
    require 'net/http'
    remaining_redirects = 3
    found = false
    until found || remaining_redirects<=0
      request_url = url.path + (url.query ? "?#{url.query}" : "")
      req = Net::HTTP::Get.new(request_url)
      req.add_field("Referer", base_url)
      req.add_field("Accept", "image/png,image/*;q=0.8,*/*;q=0.5")
      req.add_field("User-Agent", "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:2.0) Gecko/20100101 Firefox/4.0")
      res = Net::HTTP.new(url.host, url.port).start do |http|
        http.request(req)
      end
      if res.header["location"]
        url = URI.parse(res.header["location"])
        remaining_redirects-=1
      elsif res["content-type"].match(/^text\//)
        doc = Nokogiri::HTML.parse(res.body)
        elm = doc.css("img").first
        raise "Got HTML page" unless elm
        url = URI.join(url.to_s, elm["src"])
        remaining_redirects-=1
      else
        found = true
      end
    end

    raise "Too many redirects" if remaining_redirects<=0

    raise "Body length is 0" unless res.body.length>0
    raise "HTTP-Error: #{res.code} - #{res.message}" unless res.code=="200"
    return {:data=>res.body, :content_type=>res["content-type"], :url=>url}
  end

  def calculate_hash_value(data)
    require 'digest/md5'
    Digest::MD5.hexdigest(data)
  end

  def image_data_known?(hash, bytes)
    return self.strips.find_by_hash_value_and_bytes(hash, bytes)!=nil
  end

  def image_path
    RAILS_ROOT + "/public/comics/" + directory + "/"
  end

  def save_image_data(data, url, extension)
    require 'digest/md5'
    dir = image_path()
    file = Time.now.strftime("%Y%m%d-%H%M%S") + "." + extension
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

  def analyze_image_data(data)
    require 'RMagick'
    img = nil
    begin
      img = Magick::Image.from_blob(data)
    rescue
      raise "RMagick konnte das heruntergeladene Bild nicht analysieren."
    end
    
    raise "Bild ist zu klein (Breite oder Höhe < 100px)." if !ignore_size && (img[0].rows<100 || img[0].columns<100)

    ext = case img[0].format
      when "PNG" then "png"
      when "JPEG" then "jpg"
      when "GIF" then "gif"
      else raise "Unbekanntes Format: #{img[0].format}"
    end

    return ext
  end

  def get_url(element)
    base_href_value = element.document.css("head base")[0][:href] rescue ""
    URI.join(base_url, base_href_value, element["src"]) rescue nil
  end

  def rewrite_url(url)
    return url unless regexp_search && regexp_search.length>0
    URI.parse(url.to_s.gsub(Regexp.new(regexp_search), regexp_replace))
  end

  def get_new_strip(options={})
    do_debug = options[:debug] || false
    debug_data = {}
    begin
      document = get_html
      debug_data[:document] = document
      element = get_img_element(document)
      debug_data[:element] = element
      raise "Selektiertes Element ist kein img-Element" unless element && element.name=="img"
      url = get_url(element)
      debug_data[:url_original] = url
      url = rewrite_url(url)
      debug_data[:url_rewritten] = url
      all_data = get_image_data(url)
      debug_data[:image_data] = all_data
      data = all_data[:data]
      extension = analyze_image_data(data)
      debug_data[:image_extension] = extension
      hash = calculate_hash_value(data)
      debug_data[:image_hash] = hash
      length = data.length
      debug_data[:image_size] = length
    rescue => bang
      raise bang unless do_debug
      debug_data[:exception] = bang
    end
    return debug_data if do_debug

    unless image_data_known? hash, length
      filename = save_image_data(data, url, extension)
      create_strip(filename, element, url, hash, length)
      return true
    else
      return false
    end
  end
end
