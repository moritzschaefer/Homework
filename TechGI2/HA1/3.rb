#!/usr/bin/env ruby
#
l = [ 
0x00004020,
0x2009000A,
0x11090007,
0x00085080,
0x01445820,
0x8D6B0000,
0x000B1020,
0x21080001,
0x0810000D,
0x03E00008 ]

l.each do |hex|
  
  #i = [hex].pack('H*').unpack('l')
  rs = (hex & 0b0000011111111111111111111111111) >> 21
  rt = (hex & 0b0000000000111111111111111111111) >> 16
  imm = (hex & 0b0000000000000001111111111111111)
  rd = (hex & 0b0000000000000001111111111111111) >> 11
  sham = (hex & 0b0000000000000000000011111111111) >> 6
  funct = (hex & 0b0000000000000000000000000111111)
  puts "J: Op: #{hex >> 26} V: #{hex & 0b0000011111111111111111111111111}"
  puts "I: Op: #{hex >> 26} RS: #{rs} RT: #{rt} imm: #{imm}"
  puts "R: Op: #{hex >> 26} RS: #{rs} RT: #{rt} RD: #{rd} Sham: #{sham} funct: #{funct}"
  puts
end
