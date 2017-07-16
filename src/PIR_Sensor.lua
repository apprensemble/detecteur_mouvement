-- traduction de ce projet http://blog.makezine.com/projects/pir-sensor-arduino-alarm/
-- En gros je passe de arduino/C vers NodeMCU/Lua

ledPin = 3
inputPin = 4
speakerPin = 2
lastState = gpio.LOW
state = 0; -- variable val a l'origine mais etat c'est mieux, state en english

function setup() 
  pwm.setup(speakerPin, 100, 512)
  gpio.mode(ledPin,gpio.OUTPUT)
  gpio.mode(inputPin,gpio.INPUT)
  gpio.write(ledPin, gpio.LOW)
end

function bipbip(state,tmp)
  if state == gpio.HIGH 
    then
      pwm.start(speakerPin)
      gpio.write(ledPin,gpio.HIGH)
      if (lastState == gpio.LOW) then
	print "mouvement detecté!"
	lastState = gpio.HIGH
      end
    else
      pwm.stop(speakerPin)
      gpio.write(ledPin, gpio.LOW)
      if lastState == gpio.HIGH then
	print "ça ne bouge plus...C'est vide"
	lastState = gpio.LOW
      end
    end
  end
  setup()
  gpio.trig(inputPin, "both", bipbip)
