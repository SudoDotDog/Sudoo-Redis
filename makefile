# Paths
build := typescript/tsconfig.build.json
dev := typescript/tsconfig.dev.json

# NPX functions
tsc := node_modules/.bin/tsc
ts_node := node_modules/.bin/ts-node
mocha := node_modules/.bin/mocha

example_tag := suduoo-redis-example

redis_master_tag := sudoo-redis-master
redis_slave_tag := sudoo-redis-slave
redis_sentinel_tag := sudoo-redis-sentinel
redis_master_cli_tag := sudoo-redis-cli-master
redis_slave_cli_tag := sudoo-redis-cli-slave

redis_network := sudoo-redis-network

redis_singler := sudoo-redis-singler

.IGNORE: clean-linux stop-redis stop-cli stop-example stop-singler

main: dev

dev:
	@echo "[INFO] Building for development"
	@NODE_ENV=development $(tsc) --p $(dev)

example:
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

stop: stop-cli stop-example stop-redis stop-singler

stop-example:
	@echo "[INFO] Terminate Example"
	@docker kill $(example_tag)
	@docker rm $(example_tag)

host: dev
	@echo "[INFO] Running example"
	@docker run -it --name $(example_tag) --network $(redis_network) \
	-v $(shell pwd):/app mhart/alpine-node:12 \
	/bin/sh

stop-redis:
	@echo "[INFO] Terminate Redis"
	@docker kill $(redis_master_tag)
	@docker kill $(redis_slave_tag)
	@docker kill $(redis_sentinel_tag)
	@docker rm $(redis_master_tag)
	@docker rm $(redis_slave_tag)
	@docker rm $(redis_sentinel_tag)
	@docker network rm $(redis_network)

redis: stop-redis
	@echo "[INFO] Running redis with Docker"
	@docker network create $(redis_network)
	@docker run -dit --name $(redis_master_tag) --network $(redis_network) --network-alias $(redis_master_tag) \
	redis:latest
	@docker run -dit --name $(redis_slave_tag) --network $(redis_network) --network-alias $(redis_slave_tag) \
	redis:latest \
	/bin/sh -c "redis-server --slaveof $(redis_master_tag) 6379"
	@docker run -dit --name $(redis_sentinel_tag) --network $(redis_network) --network-alias $(redis_sentinel_tag) \
	-v $(shell pwd)/cluster/sentinel.conf:/redis/sentinel.conf redis:latest \
	/bin/sh -c "redis-sentinel /redis/sentinel.conf"

redis-master:
	@docker run -dit --name $(redis_master_tag) --network $(redis_network) --network-alias $(redis_master_tag) \
	redis:latest

redis-slave:
	@docker run -dit --name $(redis_slave_tag) --network $(redis_network) --network-alias $(redis_slave_tag) \
	redis:latest \
	/bin/sh -c "redis-server --slaveof $(redis_master_tag) 6379"

stop-cli:
	@echo "[INFO] Terminate Cli"
	@docker kill $(redis_master_cli_tag)
	@docker kill $(redis_slave_cli_tag)
	@docker rm $(redis_master_cli_tag)
	@docker rm $(redis_slave_cli_tag)

master:
	@echo "[INFO] Running redis CLI Master"
	@docker run -it --name $(redis_master_cli_tag) --network $(redis_network) redis:latest /bin/sh -c "redis-cli -h $(redis_master_tag) -p 6379"

slave: 
	@echo "[INFO] Running redis CLI Slave"
	@docker run -it --name $(redis_slave_cli_tag) --network $(redis_network) redis:latest /bin/sh -c "redis-cli -h $(redis_slave_tag) -p 6379"

stop-singler:
	@echo "[INFO] Terminate Redis"
	@docker kill $(redis_singler)
	@docker rm $(redis_singler)

singler: 
	@echo "[INFO] Starting Redis Singler"
	@docker run -it -p 6379:6379 --name $(redis_singler) redis:latest
