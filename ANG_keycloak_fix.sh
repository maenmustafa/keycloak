#!/bin/bash

# ==============================================================================
# apply_keycloak_fix.sh
# Fix Keycloak username lowercasing issue for SAP Business One (FP2502 / FP2502 HF1)
# ==============================================================================

# Configuration
KEYCLOAK_DIR="/usr/sap/SAPBusinessOne/Common/keycloak/lib/lib/main"
BACKUP_SUFFIX=".bak"
OWNER="b1service0:b1service0"
TAR_FILE="keycloak_tolowercase.tar.gz"
LOG_FILE="./apply_keycloak_fix.log"

# List of affected JAR files
JAR_FILES=(
  "org.keycloak.keycloak-crypto-default-24.0.4.jar"
  "org.keycloak.keycloak-model-jpa-24.0.4.jar"
  "org.keycloak.keycloak-model-storage-24.0.4.jar"
  "org.keycloak.keycloak-model-storage-private-24.0.4.jar"
  "org.keycloak.keycloak-server-spi-24.0.4.jar"
  "org.keycloak.keycloak-server-spi-private-24.0.4.jar"
  "org.keycloak.keycloak-services-24.0.4.jar"
)


log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') | $1" | tee -a "$LOG_FILE"
}

backup_originals() {
  log "Backing up original JAR files..."
  cd "$KEYCLOAK_DIR" || { log "Failed to change directory to $KEYCLOAK_DIR"; exit 1; }
  for jar in "${JAR_FILES[@]}"; do
    if [ -f "$jar" ]; then
      cp "$jar" "${jar}${BACKUP_SUFFIX}"
      log "Backed up $jar to ${jar}${BACKUP_SUFFIX}"
    else
      log "Warning: $jar not found, skipping backup."
    fi
  done
}

replace_jars() {
  log "Copying new JAR files to $KEYCLOAK_DIR..."
  cp ./org.keycloak* "$KEYCLOAK_DIR/" || { log "Failed to copy JAR files"; exit 1; }
}

set_permissions() {
  log "Setting permissions and ownership..."
  cd "$KEYCLOAK_DIR" || { log "Failed to change directory to $KEYCLOAK_DIR"; exit 1; }
  for jar in "${JAR_FILES[@]}"; do
    chmod 775 "$jar"
    chown "$OWNER" "$jar"
    log "Updated permissions and ownership for $jar"
  done
}

restart_service() {
  log "Restarting SAP B1 Authentication Service..."
  service sapb1servertools-authentication restart
  log "Service restart command issued."
}

# ==============================================================================
# Processing 
# ==============================================================================

log "Starting Keycloak fix application..."

# Step 1: Extract tar.gz if exists
if [ -f "$TAR_FILE" ]; then
  log "Extracting $TAR_FILE..."
  tar -xvf "$TAR_FILE" | tee -a "$LOG_FILE"
else
  log "Tar file $TAR_FILE not found. Please make sure it is in the same directory."
  exit 1
fi


backup_originals


replace_jars


set_permissions

# Important note
log "IMPORTANT: Please manually delete all users except 'b1siteuser' from the Authentication Service before proceeding and then manually restart authentication service after deletion"

 

log "Keycloak fix applied successfully."
echo -e "\n All steps completed. Please now login to SAP Business One to verify.\n"
