# push_to_influx.py
import json
import requests
from datetime import datetime

with open("kpi_result.json", "r") as f:
    data_list = json.load(f)

latest = data_list[-1]

payload = {
    "measurement": "kpi_data",
    "tags": {
        "site": latest["site_id"]
    },
    "time": latest["timestamp"],
    "fields": {
        "latency_ms": float(latest["latency_ms"]),
        "packet_loss_pct": float(latest["packet_loss_pct"]),
        "throughput_tcp_mbps": float(latest["throughput_tcp_mbps"])
    }
}

# InfluxDB params
url = "http://localhost:8086/write?db=kpidb"
headers = {"Content-Type": "application/json"}

# Line Protocol format
line = f'kpi_data,site={latest["site_id"]} latency_ms={latest["latency_ms"]},packet_loss_pct={latest["packet_loss_pct"]},throughput_tcp_mbps={latest["throughput_tcp_mbps"]} {int(datetime.strptime(latest["timestamp"], "%Y-%m-%dT%H:%M:%S%z").timestamp())}000000000'

requests.post(url, data=line, headers={"Content-Type": "text/plain"})
