server {
	# Ports to listen on
	listen 80;
	listen [::]:80;

	# Server name to listen for
	server_name wordpress.caojietest.com;

	# Path to document root
	root /sites/wordpress.caojietest.com/public;

	# File to be used as index
	index index.php;

	# Overrides logs defined in nginx.conf, allows per site logs.
	access_log /sites/wordpress.caojietest.com/logs/access.log;
	error_log /sites/wordpress.caojietest.com/logs/error.log;

	# Default server block rules
	include global/server/defaults.conf;

	location / {
		try_files $uri $uri/ /index.php?$args;
	}

	location ~ \.php$ {
		try_files $uri =404;
		include global/fastcgi-params.conf;

		# Use the php pool defined in the upstream variable.
		# See global/php-pool.conf for definition.
		fastcgi_pass   $upstream;
	}
}

# Redirect www to non-www
server {
	listen 80;
	listen [::]:80;
	server_name www.wordpress.caojietest.com;

	return 301 $scheme://wordpress.caojietest.com$request_uri;
}
