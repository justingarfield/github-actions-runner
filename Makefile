APP_NAME="justingarfield-homeinfrastructure/github-actions-runner"

.DEFAULT_GOAL := build

build: ## Build the image
  docker build -t $(APP_NAME) .

run:
  docker run --env-file .env -it $(APP_NAME) .

compose:
  docker compose .
