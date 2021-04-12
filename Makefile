help:
	@echo "Usage:"
	@echo "    make help             prints this help."
	@echo "    make fix              fix formatting and import sort ordering."
	@echo "    make format           run the format checker (black)."
	@echo "    make lint             run the linter (flake8)."
	@echo "    make run              run the dev server."
	@echo "    make scrape           run the scraper."
	@echo "    make setup            set up/update the local dev env."
	@echo "    make sort             run the sort checker (isort)."

.PHONY: fix
fix:
	poetry run black .
	poetry run isort .

.PHONY: format
format:
	@echo "Running black" && \
		poetry run black --check . \
		|| exit 1

.PHONY: lint
lint:
	@echo "Running flake8" && \
		poetry run flake8 \
		|| exit 1

.PHONY: run
run:
	python manage.py runserver

.PHONY: scrape
scrape:
	poetry run python scrape.py

.PHONY: setup
setup:
	poetry install

.PHONY: sort
sort:
	@echo "Running isort" && \
		poetry run isort --check-only --diff . \
		|| exit 1
