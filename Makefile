# Local
install:
	@go get -u ./src
	@echo "All package installed"

run:
	@go run ./src/main.go

watch:
	@air -c air.conf

build:
	@go build -o ./build/main ./src

docker-dev:
	@docker-compose -f docker-compose.yml up --build -d

docker-prod:
	@docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d --build

kill-port:
	@kill -9 $$(lsof -t -i:8080)
	@echo "Port 8080 is killed"

test:
	@go test ./__tests__/ -v -coverpkg=./... -coverprofile=coverage.out.tmp ./...
	@cat coverage.out.tmp | grep -v "app/application.go" | grep -v "database/" > coverage.out
	@go tool cover -func=coverage.out
	@go tool cover -html=coverage.out
	@rm -f coverage.out coverage.out.tmp

lint:
	@golangci-lint -E bodyclose,misspell,gocyclo,dupl,gofmt,golint,unconvert,goimports,depguard,gocritic,funlen,interfacer run