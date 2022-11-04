echo generating backup
now=`date +%d%b%Y.backup` 
name="../Btest$now"
/usr/local/opt/libpq/bin/pg_dump -U admin -p 5436 -h localhost test > "$name"
echo complete backup