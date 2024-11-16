read -p "hostname: " hostname
echo Password:
read -s password
#echo
#echo $hostname $password
/usr/bin/java -Djava.security.properties=idrac.java.security -cp avctKVM2.jar com.avocent.idrac.kvm.Main ip=${hostname}-idrac kmport=5900 vport=5900 user=root passwd=$password apcp=1 version=2 vmprivilege=true "helpurl=https://${hostname}/help/contents.html"
