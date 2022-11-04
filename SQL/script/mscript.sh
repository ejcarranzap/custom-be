echo drop database
now=`date +%d%b%Y.backup` 
/usr/local/opt/libpq/bin/dropdb -p 5436 -h localhost -U admin -i -e test
echo create database 
/usr/local/opt/libpq/bin/createdb  -p 5436 -h localhost -U admin test
echo restore backup
/usr/local/opt/libpq/bin/psql -U admin -p 5436 -h localhost  test < "../test$now" 
echo complete