/**
 * @author WMXPY
 * @namespace Redis
 * @description Redis
 */

import { Cluster } from "ioredis";
import { RedisNodeConfig } from "./declare";

export class RedisManager {

    public static fromNodes(...nodes: RedisNodeConfig[]): RedisManager {

        const cluster = new Cluster(nodes);
        return new RedisManager(cluster);
    }

    public static fromNodeList(nodes: RedisNodeConfig[]): RedisManager {

        const cluster = new Cluster(nodes);
        return new RedisManager(cluster);
    }

    private _cluster: Cluster;

    private constructor(cluster: Cluster) {

        this._cluster = cluster;
    }
}
