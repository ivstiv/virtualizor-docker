#!/bin/sh

export USER_HTTP_PORT=4082          # User panel http
export USER_HTTPS_PORT=4083         # User panel https
export ADMIN_HTTP_PORT=4084         # Admin panel http
export ADMIN_HTTPS_PORT=4085        # Admin panel https
export PUID=1000                    # User ID
export PGID=1000                    # Group ID
export EMAIL=your@email.here        # Emails will be sent from this email
export PANEL_DIR=/opt/virtualizor   # Directory containing all of the panel's files