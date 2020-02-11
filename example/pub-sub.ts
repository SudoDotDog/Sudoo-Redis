/**
 * @author WMXPY
 * @namespace Example
 * @description Pub Sub
 */

import { PORT_NUMBER, TIME_IN_MILLISECONDS } from "@sudoo/magic";
import * as IORedis from "ioredis";

export const instance: IORedis.Redis = new IORedis(PORT_NUMBER.REDIS_DEFAULT_PORT, 'localhost');
export const publisher: IORedis.Redis = new IORedis(PORT_NUMBER.REDIS_DEFAULT_PORT, 'localhost');

instance.subscribe('test');
instance.on('message', (channel: string, message: string) => {
    console.log(channel, ':', message);
});

let i = 0;
setInterval(() => {
    const newValue: number = ++i;
    publisher.publish('test', newValue.toString());
}, TIME_IN_MILLISECONDS.SECOND);

