/**
 * @author WMXPY
 * @namespace Example
 * @description Cluster
 */

import { RedisManager } from "../src/manager";
import * as IORedis from "ioredis";

const a = new IORedis({
    port: 6379,
    host: 'localhost',
});

// const manager: RedisManager = RedisManager.fromNodes({
//     port: 6379,
//     host: 'localhost',
// }, {
//     port: 3280,
//     host: 'localhost',
// });
