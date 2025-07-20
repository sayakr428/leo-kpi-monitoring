# leo-kpi-monitoring
Automated KPI monitoring using iperf3, mtr, InfluxDB, and shell scripting

# LEO KPI Monitoring

This project monitors **network KPIs (latency, packet loss, throughput)** for Low Earth Orbit (LEO) satellite networks using:

- `mtr` for latency and packet loss
- `iperf3` for TCP throughput
- `bash script` to log data periodically
- `InfluxDB` to store and visualize metrics
- `Python` to push latest JSON entry to InfluxDB

---

## 🔧 Components

### 1. `kpi_test.sh`

Shell script to:
- Run `mtr` and `iperf3`
- Capture metrics
- Append results to a `kpi_result.json` file

### 2. `push_to_influx.py`

Python script to:
- Read latest JSON entry
- Push data into InfluxDB using line protocol

---

## 🕒 Automation (Cron)

To schedule every 5 minutes:

```bash
crontab -e
