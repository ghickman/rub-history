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
            "external_length": int(e_length or 0),
            "external_width": int(e_width or 0),
            "external_depth": int(e_depth or 0),
            "internal_length": int(i_length or 0),
            "internal_width": int(i_width or 0),
            "internal_depth": int(i_depth or 0),
            "weight": int(weight.text or 0),
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
