namespace :comics do
  desc "Dumps all defined comics as YAML."
  task :dump => :environment do
    puts File.join(RAILS_ROOT, "/config/comics.yaml")
    default_values = Comic.new
    string = "# This file contains multiple comic definitions. There can be up to two versions\n"
    string+= "# within your instance of Rubycom:\n"
    string+= "#   tmp/comics.yml - Created by the comiclist-update.\n"
    string+= "#   config/comics.yml - Included in the repository, used as a fallback if tmp isn't\n"
    string+= "#                       writeable. Can be created with your local comic definitions\n"
    string+= "#                       by running 'rake comics:dump'.\n"
    string+= "# \n"
    string+= "# If you want to contribute new comics to the repository, run 'rake comics:dump'\n"
    string+= "# and then commit your config/comics.yml, push it and issue a pull request."
    string+= "\n"
    string+= "\n"
    string+= "\n"
    string+= "---\n"
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

