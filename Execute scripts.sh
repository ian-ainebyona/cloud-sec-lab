# 1. Make the scripts executable
chmod +x docker_installation.sh docker_properties.sh

# 2. Run Docker engine installation
./docker_installation.sh

# 3. Apply user socket permissions & group bindings
./docker_properties.sh