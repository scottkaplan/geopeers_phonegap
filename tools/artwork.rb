#!/usr/bin/ruby

require 'rubygems'
require 'RMagick'
include Magick

ARTWORKS = [
            { src_file:          'icon_512x512.png',
              dst_file:          'res/ios/icon-60.png',
              target_resolution: '60x60',
            },
            { src_file:          'icon_512x512.png',
              dst_file:          'res/ios/icon-60@2x.png',
              target_resolution: '120x120',
            },
            { src_file:          'icon_512x512.png',
              dst_file:          'res/ios/icon-76.png',
              target_resolution: '76x76',
            },
            { src_file:          'icon_512x512.png',
              dst_file:          'res/ios/icon-76@2x.png',
              target_resolution: '152x152',
            },
            { src_file:          'icon_512x512.png',
              dst_file:          'res/ios/icon-40.png',
              target_resolution: '40x40',
            },
            { src_file:          'icon_512x512.png',
              dst_file:          'res/ios/icon-40@2x.png',
              target_resolution: '80x80',
            },
            { src_file:          'icon_512x512.png',
              dst_file:          'res/ios/icon-57.png',
              target_resolution: '57x57',
            },
            { src_file:          'icon_512x512.png',
              dst_file:          'res/ios/icon-57@2x.png',
              target_resolution: '114x114',
            },
            { src_file:          'icon_512x512.png',
              dst_file:          'res/ios/icon-72.png',
              target_resolution: '72x72',
            },
            { src_file:          'icon_512x512.png',
              dst_file:          'res/ios/icon-72@2x.png',
              target_resolution: '144x144',
            },
            { src_file:          'icon_512x512.png',
              dst_file:          'res/ios/icon-small.png',
              target_resolution: '29x29',
            },
            { src_file:          'icon_512x512.png',
              dst_file:          'res/ios/icon-small@2x.png',
              target_resolution: '58x58',
            },
            { src_file:          'icon_512x512.png',
              dst_file:          'res/ios/icon-50.png',
              target_resolution: '50x50',
            },
            { src_file:          'icon_512x512.png',
              dst_file:          'res/ios/icon-50@2x.png',
              target_resolution: '100x100',
            },

            { src_file:          'splash_screen_720x1280.png',
              dst_file:          'res/ios/Default.png',
              target_resolution: '320x480',
            },
            { src_file:          'splash_screen_720x1280.png',
              dst_file:          'res/ios/Default@2x.png',
              target_resolution: '640x960',
            },
            { src_file:          'splash_screen_720x1280.png',
              dst_file:          'res/ios/Default-568h@2x.png',
              target_resolution: '640x1136',
            },
            { src_file:          'splash_screen_720x1280.png',
              dst_file:          'res/ios/Default-Portrait.png',
              target_resolution: '768x1024',
            },
            { src_file:          'splash_screen_720x1280.png',
              dst_file:          'res/ios/Default-Landscape.png',
              target_resolution: '1024x768',
            },
            { src_file:          'splash_screen_720x1280.png',
              dst_file:          'res/ios/Default-Portrait@2x.png',
              target_resolution: '1536x2048',
            },
            { src_file:          'splash_screen_720x1280.png',
              dst_file:          'res/ios/Default-Landscape@2x.png',
              target_resolution: '2048x1536',
            },
            
            { src_file:          'icon_512x512.png',
              dst_file:          'res/android/ldpi.png',
              target_resolution: '36x36',
            },
            { src_file:          'icon_512x512.png',
              dst_file:          'res/android/mdpi.png',
              target_resolution: '48x48',
            },
            { src_file:          'icon_512x512.png',
              dst_file:          'res/android/hdpi.png',
              target_resolution: '72x72',
            },
            { src_file:          'icon_512x512.png',
              dst_file:          'res/android/xhdpi.png',
              target_resolution: '96x96',
            },
            { src_file:          'splash_screen_720x1280.png',
              dst_file:          'res/android/screen-ldpi-portrait.png',
              target_resolution: '200x320',
            },
            { src_file:          'splash_screen_720x1280.png',
              dst_file:          'res/android/screen-mdpi-portrait.png',
              target_resolution: '320x480',
            },
            { src_file:          'splash_screen_720x1280.png',
              dst_file:          'res/android/screen-hdpi-portrait.png',
              target_resolution: '480x800',
            },
            { src_file:          'splash_screen_720x1280.png',
              dst_file:          'res/android/screen-xhdpi-portrait.png',
              target_resolution: '720x1280',
            },
            { src_file:          'splash_screen_720x1280.png',
              dst_file:          'res/android/screen-ldpi-landscape.png',
              target_resolution: '320x200',
            },
            { src_file:          'splash_screen_720x1280.png',
              dst_file:          'res/android/screen-mdpi-landscape.png',
              target_resolution: '480x320',
            },
            { src_file:          'splash_screen_720x1280.png',
              dst_file:          'res/android/screen-hdpi-landscape.png',
              target_resolution: '800x480',
            },
            { src_file:          'splash_screen_720x1280.png',
              dst_file:          'res/android/screen-xhdpi-landscape.png',
              target_resolution: '1280x720',
            }
           ]

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
