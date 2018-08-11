# fresh clone
if [ $1 ]
then
    echo ""
else 
    echo "please input a netboard name"
    exit 2
fi
./install-local.sh $(pwd) $1
