#!/bin/bash

# Cambiar al directorio auto
cd
cd auto || { echo "El directorio 'auto' no existe."; exit 1; }

# Ejecutar la prueba con Playwright
npm run test &> /dev/null # Redirigir la salida a /dev/null

# Verificar si el archivo timelineItems.json fue creado
if [ -f "timelineItems.json" ]; then
  # Mostrar **solo la última línea** del archivo
  cat timelineItems.json
else
  echo "El archivo timelineItems.json no fue encontrado. Asegúrate de que la prueba se ejecutó correctamente."
fi
