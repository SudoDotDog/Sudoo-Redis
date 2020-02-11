/**
 * @author WMXPY
 * @namespace Example
 * @description Cluster
 */

import * as IORedis from "ioredis";

const redis = new IORedis({
    maxRetriesPerRequest: 100,
    sentinels: [
        { host: "sudoo-redis-sentinel", port: 26379 },
    ],
    name: "mymaster",
});
let i = 0;
setInterval(() => {
    redis.set(i++ + '', "bar");
}, 1000);

