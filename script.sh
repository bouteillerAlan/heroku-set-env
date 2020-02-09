#!/bin/sh
# platform check
echo "\e[36m------------------------------------------------------------------------------\e[0m"
echo "📡 Sur quelle plateforme voulez vous set les variables d'environnement ?"
echo "\e[36m------------------------------------------------------------------------------\e[0m"
read platform

treadFile() {
  echo "chargement du fichier"
  while read line;
    do heroku config:set -r "$platform" "$line";
  done < "$addFileValue"
  core
}

addFile() {
  echo "\e[36m------------------------------------------------------------------------------\e[0m"
  echo "🧾 Qu'elle est le fichier que vous souhaitez ajouter ?"
  echo "✨ A tout moment taper q pour revenir au menu précédent"
  echo "\e[36m------------------------------------------------------------------------------\e[0m"
  read addFileValue
  case "$addFileValue" in
    [Qq]* ) core;;
    [A-Za-z]* ) treadFile;;
    * ) echo "\e[31m❌ Merci d'entrée une valeur \e[0m" && addFile;;
  esac
}

addMan() {
  echo "\e[36m------------------------------------------------------------------------------\e[0m"
  echo "🧾 Qu'elle valeur voulez vous ajouter ? [key='value']"
  echo "✨ A tout moment taper q pour revenir au menu précédent"
  echo "\e[36m------------------------------------------------------------------------------\e[0m"
  read value
  case "$value" in
    [Qq]* ) core;;
    [A-Za-z]* ) heroku config:set -r "$platform" "$value" && addMan;;
    * ) echo "\e[31m❌ Merci d'entrée une valeur \e[0m" && addMan;;
  esac
}

# function for add a value
add() {
  echo "\e[36m------------------------------------------------------------------------------\e[0m"
  echo "🧾 Voulez vous charger un fichier de variable ? [o]ui/[n]on"
  echo "✨ A tout moment taper q pour revenir au menu précédent"
  echo "\e[36m------------------------------------------------------------------------------\e[0m"
  read addChoice
  case "$addChoice" in
    [Qq]* ) core;;
    [Oo]* ) addFile;;
    [Nn]* ) addMan;;
    * ) echo "\e[31m❌ Merci d'entrée une valeur \e[0m" && add;;
  esac
}

# function for delete a value
delete() {
  echo "\e[36m------------------------------------------------------------------------------\e[0m"
  echo "💥 Qu'elle valeur voulez vous supprimer ?"
  echo "✨ A tout moment taper q pour revenir au menu précédent"
  echo "\e[36m------------------------------------------------------------------------------\e[0m"
  read value
  case "$value" in
    [Qq]* ) core;;
    [A-Za-z]* ) heroku config:unset -r "$platform" "$value" && delete;;
    * ) echo "\e[31m❌ Merci d'entrée une valeur \e[0m" && delete;;
  esac
}

# core function
core() {
  echo "\e[36m------------------------------------------------------------------------------\e[0m"
  echo "💬 Voulez vous [a]jouter, [s]upprimer ou [l]ire les variable d'environnement ?"
  echo "✨ A tout moment taper q pour sortir du script"
  echo "\e[36m------------------------------------------------------------------------------\e[0m"
  read choice
  case "$choice" in
    [Aa] ) add;;
    [Ss] ) delete;;
    [Ll] ) heroku config -r "$platform" && core;;
    [Qq] ) exit;;
    * ) echo "\e[31m❌ Merci d'entrée une valeur \e[0m" && core;;
  esac
}

# check if value is null
case "$platform" in
  [Qq] ) exit;;
  [A-Za-z]* ) core;;
  * ) echo "\e[31m❌ Merci d'entrée une valeur \e[0m";;
esac
