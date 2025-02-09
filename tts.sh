#!/bin/bash
# Salir inmediatamente si ocurre un error
set -e

# Función para detener los procesos iniciados y enviar notificación
cleanup() {
  echo "Deteniendo servidores..."
  notify-send "Servidor" "Deteniendo servidores..."
  kill $PYTHON_PID $NPM_PID
  exit 0
}

# Capturar las señales de terminación y salida para ejecutar cleanup
trap cleanup SIGINT SIGTERM EXIT

# Iniciar el servidor Python en segundo plano
cd ~/openai-edge-tts || exit 1

# Comprobar y activar el entorno virtual
if [ -f "venv/bin/activate" ]; then
  echo "Activando entorno virtual..."
  notify-send "Servidor Python" "Activando entorno virtual..."
  source venv/bin/activate
else
  echo "Entorno virtual no encontrado en ~/openai-edge-tts/venv. Por favor, crea uno."
  notify-send "Error" "Entorno virtual no encontrado en ~/openai-edge-tts/venv."
  exit 1
fi

echo "Iniciando servidor Python..."
notify-send "Servidor Python" "Iniciando servidor Python..."
python app/server.py &
PYTHON_PID=$!

# Iniciar el servidor de desarrollo de npm en segundo plano
cd ~/tts/tts/ || exit 1
echo "Iniciando servidor de desarrollo de npm..."
notify-send "Servidor NPM" "Iniciando servidor de desarrollo de npm..."
npm run dev &
NPM_PID=$!

# Esperar 2 segundos para asegurarse de que los servidores se inicien
sleep 2

echo "Abriendo Chromium en modo app en http://localhost:5173..."
notify-send "Navegador" "Abriendo Firefox en http://localhost:5173..."
firefox http://localhost:5173

# Esperar a que terminen los procesos para poder capturar la señal de salida
wait $PYTHON_PID $NPM_PID
