echo generating backup
now=`date +%d%b%Y.backup` 
name="../Btest$now"
echo "../test$now"
/usr/lib/postgresql/14/bin/pg_dump -U admin -p 5436 -h localhost test > "$name"
echo complete backup
