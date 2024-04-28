#!/bin/bash -x
gateway_ip=`/sbin/route | awk '/^default/{print $2}'`
gateway_device=`/sbin/route | awk '/^default/{print $NF}'`
dns_servers=`awk '/^nameserver/{print $2}' /etc/resolv.conf`
for denys_ip in docker.for.mac.localhost 192.168.65.1 vmi1527139.contaboserver.net 91.215.61.157 simfero.kscrimea.org simfero.tezcrimea.org kp.climatworld.com external-nms.enmarksystems.com $gateway_ip $dns_servers; do
	/sbin/route add -host $denys_ip gw $gateway_ip dev $gateway_device
done

echo ...Variables..............
echo PULSE_SERVER=$PULSE_SERVER
echo DISPLAY=$DISPLAY
echo ..........................
export PULSE_SERVER
export DISPLAY

# Cleanup to be "stateless" on startup, otherwise pulseaudio daemon can't start
rm -rf /var/run/pulse /var/lib/pulse /root/.config/pulse
# Load pulseaudio virtual audio source
pulseaudio -D --verbose --exit-idle-time=-1

# Create virtual output device (used for audio playback)
pactl load-module module-null-sink sink_name=DummyOutput sink_properties=device.description="Virtual_Dummy_Output"

# Create virtual microphone output, used to play media into the "microphone"
pactl load-module module-null-sink sink_name=MicOutput sink_properties=device.description="Virtual_Microphone_Output"

# Set the default source device (for future sources) to use the monitor of the virtual microphone output
pacmd set-default-source MicOutput.monitor

# Create a virtual audio source linked up to the virtual microphone output
pacmd load-module module-virtual-source source_name=VirtualMic

# Allow pulse audio to be accssed via TCP (from localhost only), to allow other users to access the virtual devices
pacmd load-module module-native-protocol-tcp auth-ip-acl=$PULSE_SERVER_IP

mkdir -p /home/dpimienov/.pulse
echo "default-server = $PULSE_SERVER_IP" > /home/dpimienov/.pulse/client.conf
chown -R dpimienov:dpimienov /home/dpimienov/.pulse -R
# whatever you'd like to do next

rm -vf /var/run/dbus/pid.* /var/run/xrdp/*.pid
#for init_script in dbus pulseaudio-enable-autospawn alsa-utils xrdp; do
for init_script in dbus xrdp; do
	/etc/init.d/${init_script} start 
done
while sleep 1h; do
	wait
done
