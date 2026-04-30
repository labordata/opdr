import requests
import urllib3

# olmsapps.dol.gov stopped sending its intermediate cert in April 2026,
# breaking chain validation. Skip verification — this is a public bulk data feed.
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)


while True:
    response = requests.post(
        "https://olmsapps.dol.gov/olpdr/GetYearlyDownlaodFilenamesServlet",
        verify=False,
    )
    if "2000" in response.json()["filenames"]:
        break

print(" ".join(reversed(response.json()["filenames"])))
