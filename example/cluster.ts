/**
 * @author WMXPY
 * @namespace Example
 * @description Cluster
 */

import { RedisManager } from "../src/manager";

const manager: RedisManager = RedisManager.fromNodes({
    port: 6379,
    host: 'localhost',
}, {
    port: 3280,
    host: 'localhost',
});
