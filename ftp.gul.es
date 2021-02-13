server {
  server_name ftp.gul.es ftp.gul.uc3m.es;

  root /var/www/mirrors/debian;
  
  autoindex on;
  sendfile on;
  sendfile_max_chunk 1m;
  tcp_nopush on;
  tcp_nodelay on;
  keepalive_timeout 65;
}
