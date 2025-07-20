# LEO KPI Monitoring

Automated KPI monitoring using iperf3, mtr, InfluxDB, and shell scripting 

This project monitors **network KPIs (latency, packet loss, throughput)** for Low Earth Orbit (LEO) satellite networks using:

- `mtr` for latency and packet loss
- `iperf3` for TCP throughput
- `bash script` to log data periodically
- `InfluxDB` to store and visualize metrics
- `Python` to push latest JSON entry to InfluxDB

---

## ✅ 1. Install Required Packages

```bash
sudo apt update
sudo apt install -y iperf3 mtr curl python3 python3-pip influxdb chronograf
pip3 install influxdb

#monitor iperf3 is running:
pgrep -af iperf3
```


## ✅ 2. Enable and Start InfluxDB & Chronograf

```bash
sudo systemctl enable influxdb
sudo systemctl start influxdb

sudo systemctl enable chronograf
sudo systemctl start chronograf
```

## ✅ 3. Start iperf3 Server (On Central Node)

```bash
# Run in foreground
iperf3 -s

# OR run in background with logs
nohup iperf3 -s > /var/log/iperf3_server.log 2>&1 &

#Verify iperf3 Server is Running
ps aux | grep iperf3
```

## ✅ 4. Make KPI Bash Script Executable

```bash
chmod +x kpi_test.sh
```

## ✅ 5. Set Up Cron Job to Run Script Periodically

```bash
crontab -e

#Then add this line to run the script every 10 minutes
*/10 * * * * /home/gimec/kpi_test.sh

#Verify Cron Job
crontab -l
grep CRON /var/log/syslog

#Check if cron job is executing
grep CRON /var/log/syslog
```

## ✅ 6. Push JSON to InfluxDB (Manually for Testing)

```bash
python3 push_to_influx.py

#Check if InfluxDB is active
systemctl status influxdb
```

## ✅ 7. Create Database in InfluxDB (First Time Only)

```bash
influx

#Inside the Influx shell:
CREATE DATABASE kpi_data;
exit
```

## ✅ 8. Access Chronograf Dashboard

```bash

#Check if Chronograf is active
systemctl status chronograf

#Access Chronograf Dashboard
http://<your-vm-ip>:8888 #I can't provide the ip address here , but u need to put the ip of ur vm where u have set up the applications , and need to provide the port number where ur application/service is running
```

## ✅ 9. Stop the Services

```bash

sudo systemctl stop influxdb
sudo systemctl stop chronograf
```
