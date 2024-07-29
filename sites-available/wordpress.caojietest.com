server {
        # Ports to listen on
        listen 443 ssl;
        listen [::]:443 ssl;

        # Server name to listen for
        server_name wordpress.caojietest.com;

        # Path to document root
        root /sites/azurefile/wordpress.caojietest.com/public;

        # File to be used as index
        index index.php;

        ssl_certificate /sites/azurefile/wordpress.caojietest.com/ssl/certificate.crt;
        ssl_certificate_key /sites/azurefile/wordpress.caojietest.com/ssl/private.key;

        # Overrides logs defined in nginx.conf, allows per site logs.
        access_log /sites/azurefile/wordpress.caojietest.com/logs/access.log;
        error_log /sites/azurefile/wordpress.caojietest.com/logs/error.log;

        # Default server block rules
        # include global/server/defaults.conf;

        location / {
                try_files $uri $uri/ /index.php?$args;
        }

        location ~ \.php$ {
        try_files $uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/run/php/php8.3-fpm.sock;
        fastcgi_index index.php;
        include fastcgi.conf;
    }
}
