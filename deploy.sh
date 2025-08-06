set -e

echo "--- Iniciando Despliegue Sencillo ---"

if ! command -v docker &> /dev/null
then
    echo "ERROR: Docker no está instalado. Por favor, instálalo para continuar."
    exit 1
fi
echo "Paso 1: Docker encontrado."

echo "Paso 2: Limpiando contenedores antiguos (si existen)..."
docker stop evaluacion-isv-container > /dev/null 2>&1 || true
docker rm evaluacion-isv-container > /dev/null 2>&1 || true

echo "Paso 3: Construyendo la imagen 'evaluacion-isv-app'..."
docker build -t evaluacion-isv-app .


echo "Paso 4: Ejecutando el contenedor..."
docker run -d -p 8080:8080 \
  --name evaluacion-isv-container \
  -e PORT=8080 \
  -e NODE_ENV=production \
  evaluacion-isv-app

echo "Paso 5: Esperando 5 segundos para que inicie la aplicación..."
sleep 5

echo "Paso 6: Realizando prueba de salud..."
curl --fail --silent http://localhost:8080/health

echo ""
echo "--------------------------------------------------------"
echo "¡DESPLIEGUE COMPLETADO CON ÉXITO!"
echo "La aplicación está disponible en http://localhost:8080"
echo "--------------------------------------------------------"