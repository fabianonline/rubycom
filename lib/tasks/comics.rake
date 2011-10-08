namespace :comics do
    desc "Dumps all defined comics as YAML."
    task :dump => :environment do
        default_values = Comic.new
        leader= "---\n"
        
        # FileUtils.rm Dir.glob(File.join(RAILS_ROOT, "config", "comics", "*.yml"))
        
        Comic.enabled.all.each do |comic|
            string = leader
            string += "#{comic["directory"]}:\n"
            %w(name base_url search_query regexp_search regexp_replace ignore_size).each do |attribute|
                string += "    #{attribute}: #{comic[attribute].inspect}\n" unless comic[attribute]==default_values[attribute] && %w(regexp_search regexp_replace ignore_size).include?(attribute)
            end
            string += "\n"

            File.open(File.join(RAILS_ROOT, "config", "comics", "#{comic["directory"]}.yml"), "w") do |f|
                f.write(string)
            end
        end
    end
end

