
bmp_header = [
  0x42, 0x4D, # 2 bytes: signature "BM"

  6, 0, 3, 0, # 4 bytes: file size in bytes (196662 bytes)

  0, 0, 0, 0, # 4 bytes: unused (reserved)

  54, 0, 0, 0, # 4 bytes: offset to pixel data
]

bmp_info_header = [
  40, 0, 0, 0, # 4 bytes: this header size

  0, 1, 0, 0, # 4 bytes: image width = 256 pixels
  0, 1, 0, 0, # 4 bytes: image height = 256 pixels

  1, 0, # 2 bytes: number of planes

  24, 0, # 2 bytes: number of colors

  0, 0, 0, 0, # 4 bytes: type of compression

  0, 0, 0, 0, # 4 bytes: compressed image size (can be zero)

  72, 0, 0, 0, # 4 bytes: pixels per meter (horizontal)
  72, 0, 0, 0, # 4 bytes: pixels per meter (vertical)

  0, 0, 0, 1, # 4 bytes: amount of colors used
  0, 0, 0, 0, # 4 bytes: number of important colors (???)
]

file = File.open('./output.bmp', 'wb')
file.write(bmp_header.pack('C*'))
file.write(bmp_info_header.pack('C*'))

pixmap = (0...256 * 256).map { [255, 255, 255] }

(0...256).each do |y|
  (0...256).each do |x|
    pixel = pixmap[y*256 + x]

    red = (255 - y)
    green = x
    blue = (255 - x)

    if x == (255 - y)
      red = 0xFF
      green = 0xFF
      blue = 0xFF
    end

    r = ( Math.sqrt((x - 127)**2 + (y - 127)**2) ).to_i
    if r > 80 && r < 120
      red = ((x * y) / 255.0).to_i
      green = (((255 - x) * y) / 255.0).to_i
      blue = (((255 - y) * x) / 255.0).to_i
    end

    pixel[0] = blue
    pixel[1] = green
    pixel[2] = red
  end
end

file.write(pixmap.flatten.pack('C*'))
file.close
