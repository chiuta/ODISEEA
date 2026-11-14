#!/bin/sh
# Păstrează index.html (pagina publică) identic cu ODISEEA.html (sursa).
cd "$(dirname "$0")" && cp ODISEEA.html index.html && echo "index.html actualizat din ODISEEA.html"
