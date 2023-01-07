if [ -f /opt/redirector/iptables ];then
	bash /opt/redirector/iptables
fi
if [ -f /etc/wireguard/wg.conf ];then
	wg-quick up wg
else
	echo "You cannot work with this router if you dont have /etc/wireguard/wg.conf"
	exit 1
fi
if [[ "$PRECOMMAND" != "" ]];then
	echo $PRECOMMAND | base64 -d | bash
fi
ls /scripts/init-scripts|while read i;do bash /scripts/init-scripts/$i;done 
supervisord
