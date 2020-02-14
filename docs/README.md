# Sudoo-Redis

[![Build Status](https://travis-ci.com/SudoDotDog/Sudoo-Redis.svg?branch=master)](https://travis-ci.com/SudoDotDog/Sudoo-Redis)
[![codecov](https://codecov.io/gh/SudoDotDog/Sudoo-Redis/branch/master/graph/badge.svg)](https://codecov.io/gh/SudoDotDog/Sudoo-Redis)
[![npm version](https://badge.fury.io/js/%40sudoo%2Fredis.svg)](https://www.npmjs.com/package/@sudoo/redis)
[![downloads](https://img.shields.io/npm/dm/@sudoo/redis.svg)](https://www.npmjs.com/package/@sudoo/redis)

:chestnut: Redis for Node

## Cheat Sheet

Sudoo Redis also an example cheat sheet for redis structure hosting

### Start Redis within Sentinel Mode

To Visit the Sentinel instance, your application must be running under docker `sudoo-redis-network` network.

```sh
make redis
```

Three redis node will be established:

- Master: `sudoo-redis-master:6379`
- Slave: `sudoo-redis-slave:6379`
- Sentinel: `sudoo-redis-sentinel:26379`

Again, these address are alias host name of nodes, they are running under `sudoo-redis-network` network.

> To Stop the Sentinel Nodes instances run `make stop-redis`

### Access Redis Node by `Redis-CLI`

```sh
make redis-master
make redis-slave
```

> To Stop the CLI instances run `make stop-cli`

### Start Singler Instances

For development, you can start a singler instance by:

```sh
make singler
```

A Redis instance will be hosted on `localhost:6379`.

> To Stop the Singler instance run `make stop-singler`
