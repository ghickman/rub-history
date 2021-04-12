import json

import requests
from bs4 import BeautifulSoup


def iter_rows(rows):
    for row in rows:
        name, external, internal, weight = row.find_all("td")

        try:
            e_length, e_width, e_depth = external.text.split(" x ")
        except Exception:
            e_length = e_width = e_depth = ""
            print(f"Unable to parse external dimensions for '{name.text}', ignoring")

        try:
            i_length, i_width, i_depth = internal.text.split(" x ")
        except Exception:
            i_length = i_width = i_depth = ""
            print(f"Unable to parse internal dimensions for '{name.text}', ignoring")

        yield {
            "name": name.text,
            "external-length": e_length,
            "external-width": e_width,
            "external-depth": e_depth,
            "internal-length": i_length,
            "internal-width": i_width,
            "internal-depth": i_depth,
            "weight": weight.text,
        }


url = "https://www.reallyusefulproducts.co.uk/uk/html/boxdetails.php"
r = requests.get(url)
r.raise_for_status()

print("Webpage retrieved")

soup = BeautifulSoup(r.content, "html.parser")

# there should only be one table but find_all returns a list
table = soup.find_all("table", class_="bluetable")[0]

# ignore first two rows which are headers
rows = table.find_all("tr")[2:]

with open("data.json", "w") as f:
    data = list(iter_rows(rows))
    json.dump(data, f)

print("data.json written")
