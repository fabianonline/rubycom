namespace :comics do
    desc "Dumps all defined comics as single YAML files to config/comics/."
    task :dump => :environment do
        default_values = Comic.new
        leader = "# This file contains a single comic strip definition.\n"
        leader+= "# It was created by rake comics:dump and can be overwritten at any time.\n"
        leader+= "# THIS FILE IS NOT DIRECTLY USED BY RUBYCOM!\n"
        leader+= "# It's only purpose is to be pushed to github and then be merged\n"
        leader+= "# into config/comics.yml by the maintainer of rubycom.\n"
        leader+= "\n"
        leader+= "  ---\n"
        
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
        
    desc "Merges all YAML files to config/comics.yml."
    task :merge => :environment do
        string = "# This file contains multiple comic strip definitions.\n"
        string+= "# It is created by rake comics:merge, which merges all the definitions from\n"
        string+= "# config/comics/, which in turn are created by rake comics:dump into this file.\n"
        string+= "# This file will be kept up to date by the maintainer of this project.\n"
        string+= "# \n"
        string+= "# This file in config/ will serve as a fallback solution for rubycom if the current\n"
        string+= "# definitions can't be downloaded from github.\n"
        string+= "# This file in tmp/ is the most recently downloaded version.\n"
        string+= "\n"
        
        Dir.glob(File.join(RAILS_ROOT, 'config', 'comics', '*.yml')).sort.each do |file|
            contents = File.open(file) {|f| f.read}
            string += contents.to_a[7..-1].join
        end
        
        File.open(File.join(RAILS_ROOT, 'config', 'comics.yml'), 'w') {|f| f.write string }
    end
end

