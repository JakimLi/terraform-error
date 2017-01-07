mkdir /home/ec2-user/server/ && cd /home/ec2-user/server/
touch index.html
echo ok >> index.html
python -m SimpleHTTPServer
