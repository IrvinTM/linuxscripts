#!/bin/bash

if [ -z "$1" ]; then
    QUERY="batman"
else
    QUERY="$1"
fi

# Definir la variable de entorno QUERY
export QUERY="$QUERY"

# Ejecutar el script de Node.js
cd streamit || { echo "El directorio 'streamit' no existe."; exit 1; }
npm run test

cd ./webplayer

brave  http://localhost:8330

node serve.js

