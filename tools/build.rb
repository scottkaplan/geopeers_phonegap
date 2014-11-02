#!/usr/bin/ruby

require '/home/geopeers/sinatra/geopeers/geo.rb'
# require 'github_api'
require 'git'
require 'fileutils'

def git_push
  github = Github.new basic_auth: 'scott@kaplans.com:scottkaplan1'

  contents = github::Client::Repos::Contents.new
  index_file = '/home/geopeers/phonegap/geopeers/index.html'
  index_html = File.read(index_file)
  file = contents.find path: index_file
  contents.update 'scott@kaplans.com', 'geopeers', index_file,
  path: index_file,
  message: 'Automated commit',
  content: index_html,
  sha: file.sha
end

def git_pull
  project_dir = '/home/geopeers/phonegap/geopeers/webapp'
  remote_rep = 'https://magtogo.gitsrc.com/git/geopeers.git'
  local_rep = '/home/geopeers/phonegap/geopeers/webapp'
  name = 'geopeers'
  g = Git.clone(remote_rep, name, {path: local_rep} )
  # git = Git.init(project_dir, {repository: local_rep})
  # git.pull
end

def write_index_html
  html = create_index({is_phonegap: true})
  output_file = '/home/geopeers/phonegap/geopeers/index.html'
  File.open(output_file, 'w') { |file| file.write(html) }
end

def edit_config_xml
  config_xml_file = "/home/geopeers/phonegap/geopeers/config.xml"
  config_xml = File.read(config_xml_file)
  build_id = get_build_id()
  puts build_id
  config_xml.sub! /versionCode\s*=\s*"\d+\"/, "versionCode = \"#{build_id}\""
  File.open(config_xml_file, 'w') { |file| file.write(config_xml) }
end

def pull_webapp
  remote_rep = 'https://scott:scott_kaplan@magtogo.gitsrc.com/git/geopeers.git'
  local_rep = '/home/geopeers/phonegap/geopeers/webapp'
  cmd = "cd #{local_rep}; rm -rf *; git clone #{remote_rep}"
  puts cmd
  result = `#{cmd}`
end

def copy_local_assets
  for asset_type in ['css', 'images', 'js']
    # clear out the local assets in the phonegap repo
    # Don't just rm -rf the directory since we want to save the repo info
    phonegap_repo = "/home/geopeers/phonegap/geopeers/#{asset_type}"
    phonegap_files = Dir.glob("#{phonegap_repo}/*")
    FileUtils.rm_r (phonegap_files)

    webapp_repo = "/home/geopeers/phonegap/geopeers/webapp/geopeers/public/#{asset_type}"
    webapp_files = Dir.glob("#{webapp_repo}/*")
    FileUtils.cp_r(webapp_files, phonegap_repo)
  end
end

def update_phonegap_repo
  # git commit
  # git push
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
