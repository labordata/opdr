import requests


while True:
    response = requests.post(
        "https://olmsapps.dol.gov/olpdr/GetYearlyDownlaodFilenamesServlet"
    )
    print(response.json())
    if "2000" in response.json()["filenames"]:
        break

print(" ".join(reversed(response.json()["filenames"])))
