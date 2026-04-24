#!/usr/bin/env bash
set -euo pipefail

LOG_FILE="oc_install.log"

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') | $1" | tee -a "$LOG_FILE"
}

OC_BIN="/usr/local/bin/oc"

log "Starting OpenShift CLI check"

# Check if oc exists AND is valid
if [ -x "$OC_BIN" ]; then
    log "oc binary found, validating..."

    if "$OC_BIN" version --client >/dev/null 2>&1; then
        log "oc is valid"
        "$OC_BIN" version --client | tee -a "$LOG_FILE"
        exit 0
    else
        log "Invalid oc binary detected. Removing..."
        sudo rm -f "$OC_BIN"
    fi
fi

log "Installing fresh oc binary..."

TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

log "Downloading oc client"
curl -LO https://mirror.openshift.com/pub/openshift-v4/clients/oc/latest/linux/oc.tar.gz

log "Extracting archive"
tar -xzf oc.tar.gz

log "Installing binary"
chmod +x oc
sudo mv oc "$OC_BIN"

log "Validating installation"
"$OC_BIN" version --client | tee -a "$LOG_FILE"

log "Installation completed"
