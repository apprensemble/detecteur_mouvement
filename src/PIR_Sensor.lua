-- traduction de ce projet http://blog.makezine.com/projects/pir-sensor-arduino-alarm/
-- En gros je passe de arduino/C vers NodeMCU/Lua

ledPin = 3
inputPin = 4
speakerPin = 2
lastState = gpio.LOW
state = 0; -- variable val a l'origine mais etat c'est mieux, state en english
data_presence = "mouvement detecté!\n"
data_absence = "ça ne bouge plus...C'est vide\n"
ip_cible = "192.168.1.28"
port_cible = 5000

function setup() 
  pwm.setup(speakerPin, 100, 512)
  gpio.mode(ledPin,gpio.OUTPUT)
  gpio.mode(inputPin,gpio.INPUT)
  gpio.write(ledPin, gpio.LOW)
  -- creation d'un socket udp
  udpSocket = net.createUDPSocket()
  -- synchro du temps
  sntp.sync()
end

function what_time() 
  tm = rtctime.epoch2cal(rtctime.get())
  return string.format("%04d/%02d/%02d %02d:%02d:%02d", tm["year"], tm["mon"], tm["day"], tm["hour"], tm["min"], tm["sec"])
end


function bipbip(state,tmp)
  if state == gpio.HIGH 
    then
      pwm.start(speakerPin)
      gpio.write(ledPin,gpio.HIGH)
      if (lastState == gpio.LOW) then
	hr = what_time()
	udpSocket:send(port_cible,ip_cible,hr..";"..data_presence)
	lastState = gpio.HIGH
      end
    else
      pwm.stop(speakerPin)
      gpio.write(ledPin, gpio.LOW)
      if lastState == gpio.HIGH then
	hr = what_time()
	udpSocket:send(port_cible,ip_cible,hr..";"..data_absence)
	lastState = gpio.LOW
      end
    end
  end
  setup()
  gpio.trig(inputPin, "both", bipbip)
