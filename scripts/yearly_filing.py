import sys
import requests


s = requests.Session()

s.get('https://olmsapps.dol.gov/olpdr/?_ga=2.153682620.544456734.1620145813-42444416.1608177889#Union%20Reports/Yearly%20Data%20Download/')

response = s.post('https://olmsapps.dol.gov/olpdr/GetYearlyDownlaodFilenamesServlet')

filings = response.json()

filing_lookup = {year: filename
                 for year, filename
                 in zip(filings["filenames"],
                        filings["encriptedFilenames"])}

response = s.get('https://olmsapps.dol.gov/olpdr/GetYearlyFileServlet?report=' + filing_lookup[sys.argv[1]], stream=True)

with open(sys.argv[2], 'wb') as f:
    f.write(response.content)
