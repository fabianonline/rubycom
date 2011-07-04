namespace :comics do
  desc "Dumps all defined comics as YAML."
  task :dump => :environment do
    puts File.join(RAILS_ROOT, "/config/comics.yaml")
    string = "---\n"
    Comic.enabled.all(:order=>:directory).each do |comic|
      string += "#{comic["directory"]}:\n"
      %w(name base_url search_query regexp_search regexp_replace).each do |name|
        string += "    #{name}: #{comic[name].inspect}\n" if comic[name] && (!comic[name].empty? || ! %w(regexp_search regexp_replace).include?(name))
      end
      string += "\n"
    end

    File.open(File.join(RAILS_ROOT, "/config/comics.yaml"), "w") do |f|
      f.write(string)
    end
    puts "Saved at config/comics.yaml"
  end
end

