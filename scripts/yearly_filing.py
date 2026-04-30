import sys
import requests
import urllib3

# olmsapps.dol.gov stopped sending its intermediate cert in April 2026,
# breaking chain validation. Skip verification — this is a public bulk data feed.
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)


for attempt in range(1000):
    print(f"attempt: {attempt}")

    s = requests.Session()
    s.verify = False

    s.get("https://olmsapps.dol.gov/olpdr/?Union%20Reports/Yearly%20Data%20Download/")

    response = s.post(
        "https://olmsapps.dol.gov/olpdr/GetYearlyDownlaodFilenamesServlet"
    )

    filings = response.json()
    if "2000" in filings["filenames"]:
        break
else:
    raise ValueError("Couldn't get the download link")


filing_lookup = {
    year: filename
    for year, filename in zip(filings["filenames"], filings["encriptedFilenames"])
}

response = s.get(
    "https://olmsapps.dol.gov/olpdr/GetYearlyFileServlet?report="
    + filing_lookup[sys.argv[1]],
    stream=True,
)

with open(sys.argv[2], "wb") as f:
    f.write(response.content)
