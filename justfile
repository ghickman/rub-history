# list available commands
default:
    @{{ just_executable() }} --list

black *args="src":
    uv run black --check {{ args }}

ruff *args="src":
    uv run ruff check {{ args }}

toml-sort *args:
    uv run toml-sort {{ args }} pyproject.toml

check: black ruff
    {{ just_executable() }} toml-sort --check

# fix formatting and import sort ordering
fix:
    uv run black src
    uv run ruff check --fix src
    {{ just_executable() }} toml-sort --in-place
    just --fmt --unstable --justfile justfile

# Run the scraper
scrape:
    uv run -m rub_history

# Build the database file
build:
    @rm -rf boxes.db
    cat data.json | uv run sqlite-utils insert boxes.db boxes -

# Deploy to vercel
deploy:
    uv run datasette publish fly boxes.db \
      --app rub-history \
      --title "Really Useful Boxes" \
      --about "ghickman/rub-history" \
      --about_url "https://github.com/ghickman/rub-history" \
      --source "Really Useful Boxes" \
      --source_url "https://www.reallyusefulproducts.co.uk/uk/html/boxdetails.php"
