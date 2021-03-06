# OLMS Online Public Disclosure Room Database
[![Update Database](https://github.com/labordata/opdr/actions/workflows/build.yml/badge.svg)](https://github.com/labordata/opdr/actions/workflows/build.yml)

Daily refreshed mirror of the [Office of Labor-Management Standards Online Public Disclosure Room Database](https://olmsapps.dol.gov/olpdr/?_ga=2.153682620.544456734.1620145813-42444416.1608177889#Union%20Reports/Yearly%20Data%20Download). Data is updated nightly at about 10:00 pm Eastern.

* [sqlite database](https://github.com/labordata/opdr/releases/download/2021-05-31/opdr.db.zip)
* [online access](https://labordata.bunkum.us/opdr)

This repository contains code to build and update a database based on the exported tables and documentation from the OLMS's Online Public Disclosure Room. This diagram shows the different tables and variables contained in the database.

![ERD Diagram](docs/erd.png)
