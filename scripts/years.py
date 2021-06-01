import requests


s = requests.Session()

response = s.post('https://olmsapps.dol.gov/olpdr/GetYearlyDownlaodFilenamesServlet')

print(' '.join(reversed(response.json()['filenames'])))
