namespace :comics do
  desc "Dumps all defined comics as YAML."
  task :dump => :environment do
    puts File.join(RAILS_ROOT, "/config/comics.yaml")
    default_values = Comic.new
    string = "---\n"
    Comic.enabled.all(:order=>:directory).each do |comic|
      string += "#{comic["directory"]}:\n"
      %w(name base_url search_query regexp_search regexp_replace ignore_size).each do |name|
        string += "    #{name}: #{comic[name].inspect}\n" unless comic[name]==default_values[name] && %w(regexp_search regexp_replace ignore_size).include?(name)
      end
      string += "\n"
    end

    File.open(File.join(RAILS_ROOT, "/config/comics.yml"), "w") do |f|
      f.write(string)
    end
    puts "Saved at config/comics.yml"
  end
end

