#!/bin/sh

export HTTP_PORT=4084               # HTTP port on the host (recommended 80)
export HTTPS_PORT=4085              # HTTPS port on the host (recommended 443)
export PUID=1000                    # User ID
export PGID=1000                    # Group ID
export EMAIL=your@email.here        # Emails will be sent from this email
export PANEL_DIR=/opt/virtualizor   # Direcotry containing all of the panel's files