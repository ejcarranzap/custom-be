echo drop database
now=`date -d "-1 days" +%d%b%Y.backup` 
name="../Btest$now"
dropdb -p 5436 -h localhost -U admin -i -e test
echo create database 
createdb  -p 5436 -h localhost -U admin test
echo restore backup
psql -U admin -p 5436 -h localhost  test < "$name" 
echo complete

