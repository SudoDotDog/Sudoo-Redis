/**
 * @author WMXPY
 * @namespace Example
 * @description Sentinel
 */

import { TIME_IN_MILLISECONDS } from "@sudoo/magic";
import * as IORedis from "ioredis";

const redis = new IORedis({
    maxRetriesPerRequest: 100,
    sentinels: [
        { host: "sudoo-redis-sentinel", port: 26379 },
    ],
    name: "my-master",
});
let i = 0;
setInterval(() => {
    const newValue: number = ++i;
    redis.set(newValue.toString(), newValue);
}, TIME_IN_MILLISECONDS.SECOND);

