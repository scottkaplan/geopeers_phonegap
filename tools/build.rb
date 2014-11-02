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
  for asset_type in ['css', 'images', 'js']
    # clear out the local assets in the phonegap repo
    # Don't just rm -rf the directory since we want to save the repo info
    phonegap_repo = "#{Phonegap_dir}/#{asset_type}"
    phonegap_files = Dir.glob("#{phonegap_repo}/*")
    FileUtils.rm_r (phonegap_files)

    webapp_repo = "#{Phonegap_dir}/webapp/geopeers/public/#{asset_type}"
    webapp_files = Dir.glob("#{webapp_repo}/*")
    FileUtils.cp_r(webapp_files, phonegap_repo)
  end
end

def update_phonegap_repo
  cmd = "cd #{Phonegap_dir}; git commit -a -m 'Phonegap'"
  puts cmd
  `#{cmd}`
  cmd = "cd #{Phonegap_dir}; git push"
  puts cmd
  `#{cmd}`
end

def build
  write_index_html()
  edit_config_xml()
  pull_webapp()
  copy_local_assets()
  update_phonegap_repo()
end

# build()
update_phonegap_repo
