#!/usr/bin/ruby

require 'rubygems'
require 'RMagick'
include Magick

ARTWORKS = [
#            { src_file:          'icon_512x512.png',
#              dst_file:          'res/android/ldpi.png',
#              target_resolution: '200x320',
#            },
            { src_file:          'icon_512x512.png',
              dst_file:          'res/android/mdpi.png',
              target_resolution: '320x480',
            },
            { src_file:          'icon_512x512.png',
              dst_file:          'res/android/hdpi.png',
              target_resolution: '480x800',
            },
            { src_file:          'icon_512x512.png',
              dst_file:          'res/android/xhdpi.png',
              target_resolution: '720x1280',
            }]

IMAGE_BASE_DIR = '/home/geopeers/sinatra/geopeers/public/images'

def create_image (image_info)
  image_file = IMAGE_BASE_DIR + '/' + image_info[:src_file]
  src_img = Magick::Image::read(image_file)[0]

  # scale src_img down so it fits within target_resolution
  
  (dst_width, dst_height) = image_info[:target_resolution].split(/x/)
  x_scale = dst_width.to_f  / src_img.columns.to_f
  y_scale = dst_height.to_f / src_img.rows.to_f
  min_scale = [x_scale,y_scale].min
  src_img_scaled = src_img.resize(min_scale)
  if (x_scale == y_scale)
    dst_img = src_img_scaled
  else
    # src and dst have different aspect ratios
    # create a white image with the dst dimensions
    dst_img = Magick::ImageList.new
    dst_img.new_image(dst_width.to_i, dst_height.to_i) {
      self.background_color = 'white'
    }
    # place the scaled src image on top of the white background
    dst_img.composite!(src_img_scaled,CenterGravity,OverCompositeOp)
  end
  dst_file = IMAGE_BASE_DIR + '/' + image_info[:dst_file]
  dst_img.write(dst_file)
end

def create_artworks (artworks)
  artworks.each { |image_info| create_image(image_info) }
end

create_artworks(ARTWORKS)
