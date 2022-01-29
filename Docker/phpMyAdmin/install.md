```
docker run --name myadmin -d --link local_mysql -e PMA_HOST="local_mysql" -e PMA_USER="root" -e PMA_PASSWORD="password" -p 8080:80 phpmyadmin
```
在本地端裝的`phpMyAdmin`
