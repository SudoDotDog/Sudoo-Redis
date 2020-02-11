# Paths
build := typescript/tsconfig.build.json
dev := typescript/tsconfig.dev.json

# NPX functions
tsc := node_modules/.bin/tsc
ts_node := node_modules/.bin/ts-node
mocha := node_modules/.bin/mocha

redis_master_tag := sudoo-redis-master
redis_slave_tag := sudoo-redis-slave
redis_cli_tag := sudoo-redis-cli

.IGNORE: clean-linux stop-redis stop-cli

main: dev

dev:
	@echo "[INFO] Building for development"
	@NODE_ENV=development $(tsc) --p $(dev)

example: dev
	@echo "[INFO] Running example"
	@NODE_ENV=development $(ts_node) example/cluster.ts

build:
	@echo "[INFO] Building for production"
	@NODE_ENV=production $(tsc) --p $(build)
	
tests:
	@echo "[INFO] Testing with Mocha"
	@NODE_ENV=test $(mocha)

cov:
	@echo "[INFO] Testing with Nyc and Mocha"
	@NODE_ENV=test \
	nyc $(mocha)

install:
	@echo "[INFO] Installing dev Dependencies"
	@yarn install --production=false

install-prod:
	@echo "[INFO] Installing Dependencies"
	@yarn install --production=true

license: clean
	@echo "[INFO] Sign files"
	@NODE_ENV=development $(ts_node) script/license.ts

clean: clean-linux
	@echo "[INFO] Cleaning release files"
	@NODE_ENV=development $(ts_node) script/clean-app.ts

clean-linux:
	@echo "[INFO] Cleaning dist files"
	@rm -rf dist
	@rm -rf .nyc_output
	@rm -rf coverage

publish: install tests license build
	@echo "[INFO] Publishing package"
	@cd app && npm publish --access=public

stop-redis:
	@echo "[INFO] Terminate Redis"
	@docker kill $(redis_master_tag)
	@docker kill $(redis_slave_tag)
	@docker rm $(redis_master_tag)
	@docker rm $(redis_slave_tag)

redis: stop-redis
	@echo "[INFO] Running redis with Docker"
	@docker run -dit -p 6379:6379 --name $(redis_master_tag) redis:latest
	@docker run -dit -p 6380:6380 --name $(redis_slave_tag) redis:latest /bin/sh -c redis-server --slaveof localhost 6379

stop-cli:
	@echo "[INFO] Terminate Cli"
	@docker kill $(redis_cli_tag)
	@docker rm $(redis_cli_tag)

cli: stop-cli
	@echo "[INFO] Running redis CLI"
	@docker run -it --name $(redis_cli_tag) redis:latest /bin/sh
