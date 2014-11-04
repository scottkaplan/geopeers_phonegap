#!/usr/bin/ruby

require '/home/geopeers/sinatra/geopeers/geo.rb'
# require 'github_api'
require 'git'
require 'fileutils'

Phonegap_dir = "/home/geopeers/phonegap/geopeers"

def write_index_html
  html = create_index({is_phonegap: true})
  output_file = "#{Phonegap_dir}/index.html"
  File.open(output_file, 'w') { |file| file.write(html) }
end

def edit_config_xml
  config_xml_file = "#{Phonegap_dir}/config.xml"
  config_xml = File.read(config_xml_file)
  build_id = get_build_id()
  puts build_id
  config_xml.sub! /versionCode\s*=\s*"\d+\"/, "versionCode = \"#{build_id}\""
  File.open(config_xml_file, 'w') { |file| file.write(config_xml) }
end

def pull_webapp
  remote_rep = 'https://scott:scott_kaplan@magtogo.gitsrc.com/git/geopeers.git'
  local_rep = "#{Phonegap_dir}/webapp"
  cmd = "cd #{local_rep}; rm -rf *; git clone #{remote_rep}"
  puts cmd
  result = `#{cmd}`
end

def copy_local_assets
  for asset_type in ['images', 'images/res', 'images/res/ios', 'images/res/android', 'css', 'js']
    puts asset_type
    phonegap_subdir = "#{Phonegap_dir}/#{asset_type}"
    Dir.foreach (phonegap_subdir) { |filename|
      phonegap_pathname = "#{phonegap_subdir}/#{filename}"
      next if File.directory?(phonegap_pathname)

      # clear out the local assets in the phonegap repo
      # Don't just rm -rf the directory since we want to save the repo info
      FileUtils.rm (phonegap_pathname)

      webapp_file = "#{Phonegap_dir}/webapp/geopeers/public/#{asset_type}/#{filename}"
      FileUtils.cp(webapp_file, phonegap_pathname)
    }
  end
end

def update_phonegap_repo
  cmd = "cd #{Phonegap_dir}; git commit -a -m 'Phonegap'"
  `#{cmd}`
  github_rep = 'https://scott@kaplans.com:scottkaplan1@github.com/scottkaplan/geopeers'
  cmd = "cd #{Phonegap_dir}; git push #{github_rep}"
  puts cmd
  `#{cmd}`
end

def build
  puts "Write index.html"
  write_index_html()
  puts "Edit config XML"
  edit_config_xml()
  puts "Pull webapp repo"
  pull_webapp()
  puts "Copy local assets"
  copy_local_assets()
  puts "Update Phonegap repo"
  update_phonegap_repo()
  puts "Done"
end

build()
