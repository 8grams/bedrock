#!/bin/bash

cp /var/www/html/web/app/plugins/sqlite-database-integration/db.copy /var/www/html/web/app/db.php

# Start Apache in the foreground
apache2-foreground