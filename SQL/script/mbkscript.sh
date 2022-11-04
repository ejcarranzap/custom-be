echo generating backup
now=`date +%d%b%Y.backup` 
echo "../test$now"
/usr/local/opt/libpq/bin/pg_dump -U admin -p 5436 -h localhost test > "../test$now"
echo complete backup