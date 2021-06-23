import sys
import requests


while True:
    s = requests.Session()

    s.get('https://olmsapps.dol.gov/olpdr/?Union%20Reports/Yearly%20Data%20Download/')
    
    response = s.post('https://olmsapps.dol.gov/olpdr/GetYearlyDownlaodFilenamesServlet')

    filings = response.json()
    if '2000' in filings['filenames']:
        break

filing_lookup = {year: filename
                 for year, filename
                 in zip(filings["filenames"],
                        filings["encriptedFilenames"])}

response = s.get('https://olmsapps.dol.gov/olpdr/GetYearlyFileServlet?report=' + filing_lookup[sys.argv[1]], stream=True)

with open(sys.argv[2], 'wb') as f:
    f.write(response.content)
