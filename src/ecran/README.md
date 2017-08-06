# Utilisation

1. Brancher l'ecran I2C (SCA -> port1 et SCL -> port2)
1. uploader init.lua et messages_udp.lua
1. lancer un terminal et tester avec les commandes :
  ```shell
  echo "Mouvement" | nc -w1 -u <ip de votre node> 5000
  echo "calme" | nc -w1 -u <ip de votre node> 5000
  ```
  Ces deux messages sont standard mais il accepte aussi d'autres messages. L'interet c'est qu'il reformule lorsqu'il voit calme ou Mouvement dans un message. ça evite d'avoir la date en doublons.
  Il faut une date réseau + une date node pour flink c'est pour cela que j'ai mis la date sur l'emetteur aussi.
