echo drop database
now=`date +%d%b%Y.backup` 
dropdb -p 5436 -h localhost -U admin -i -e test
echo create database 
createdb  -p 5436 -h localhost -U admin test
echo restore backup
psql -U admin -p 5436 -h localhost  test < "../test$now" 
echo complete

