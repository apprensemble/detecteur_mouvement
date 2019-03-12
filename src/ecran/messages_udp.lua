-- messager 1 - OLED Display messenger
-- -- Aout, 2017 
-- -- @grillon | thierry.grillon@gmail.com
-- -- Hardware: 
-- --   ESP-12E Devkit
-- --   4 pin I2C OLED 128x64 Display Module
-- -- Connections:
-- --   ESP  --  OLED
-- --   3v3  --  VCC
-- --   GND  --  GND
-- --   D1   --  SDA
-- --   D2   --  SCL
--
-- -- This program receive messages from the Internet, and displays it on the OLED.
--
-- -- Variables 
sda = 1 -- SDA Pin
scl = 2 -- SCL Pin
id = 0
entete = " "
destinataire = "     @Grillon"
message = "1234567890123456789012"
provenance = "from who?"
date = "aujourd'hui"

function setup()
  sntp.sync()
  udpSocket = net.createUDPSocket()
  udpSocket:listen(5000)
  udpSocket:on("receive", function(s, data, port, ip)
    if (data:match("calme")) then
      entete = " "
      message = "retour au calme"
    else 
      entete = "ALERTE !!"
      if (data:match("Mouvement")) then
	message = "Mouvement en cours!"
      else
	message = string.format("%s",data)
      end
    end
    date = what_time()
    provenance = string.format("from %s", ip)
    s:send(port, ip, "echo: " .. data)
    write_OLED()
  end)
  port, ip = udpSocket:getaddr()
  print(string.format("local UDP socket address / port: %s:%d", ip, port))
end

function init_OLED(sda,scl) --Set up the u8glib lib
     sla = 0x3C
     i2c.setup(id, sda, scl, i2c.SLOW)
     -- disp = u8g2.ssd1306_128x64_i2c(sla)
		 disp = u8g2.ssd1306_i2c_128x64_noname(id, sla)
     disp:setFont(u8g2.font_6x10_tf) -- about 6 lines & 21 char by line
     disp:setFontRefHeightExtendedText()
     disp:setFontPosTop()
     --disp:setRot180()           -- Rotate Display if needed
end

function what_time() 
  tm = rtctime.epoch2cal(rtctime.get())
  return string.format("%04d/%02d/%02d %02d:%02d:%02d", tm["year"], tm["mon"], tm["day"], tm["hour"]+2, tm["min"], tm["sec"])
end

function write_OLED() -- Write Display
     --disp:drawFrame(2,2,126,62)
		 disp:clearBuffer()
     disp:drawStr(5, 0, entete)
     -- disp:drawStr(5, 7, str1)
     -- disp:drawStr(40, 30,  string.format("%02d:%02d:%02d",h,m,s))
     -- disp:drawStr(5, 15, destinataire)
     disp:drawStr(0, 15, message)
     disp:drawStr(0, 35, date)
     disp:drawStr(0, 50, provenance)
		 disp:sendBuffer()
     --disp:drawXBM(0, 0, 128, 64, xbm_data)
     --disp:drawXBM( 0, 20, 38, 24, xbm_data )
     --disp:drawCircle(18, 47, 14)
end

function loadXbm() 
  file.open("u8glib_logo.xbm", "r")
  xbm_data = file.read()
  file.close()
end



-- Main Program 
init_OLED(sda,scl)
setup()
write_OLED()
