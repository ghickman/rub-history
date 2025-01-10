# list available commands
default:
    @{{ just_executable() }} --list

# upgrade dev or prod dependencies (all by default, specify package to upgrade single package)
upgrade env package="":
    #!/usr/bin/env bash
    opts="--upgrade"
    test -z "{{ package }}" || opts="--upgrade-package {{ package }}"
    uv add $opts

black *args=".":
    uv run black --check {{ args }}

ruff *args=".":
    uv run ruff check {{ args }}

toml-sort *args:
    uv run toml-sort {{ args }} pyproject.toml

check: black ruff
    {{ just_executable() }} toml-sort --check

# fix formatting and import sort ordering
fix:
    uv run black .
    uv run ruff check --fix .
    {{ just_executable() }} toml-sort --in-place
    just --fmt --unstable --justfile justfile

# Run the scraper
scrape:
    uv run -m rub_history

# Build the database file
build:
    cat data.json | uv run sqlite-utils insert boxes.db boxes -

# Deploy to vercel
deploy:
    uv run datasette publish vercel boxes.db \
      --title "Really Useful Boxes" \
      --about "ghickman/rub-history" \
      --about_url "https://github.com/ghickman/rub-history" \
      --source "Really Useful Boxes" \
      --source_url "https://www.reallyusefulproducts.co.uk/uk/html/boxdetails.php" \
      --project rub-history \
      --token $VERCEL_TOKEN
