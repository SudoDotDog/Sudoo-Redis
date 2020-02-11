/**
 * @author WMXPY
 * @namespace Redis
 * @description Redis
 * @override Unit
 */

import { expect } from 'chai';
import * as Chance from 'chance';

describe('Given a {Redis} Class', (): void => {

    const chance: Chance.Chance = new Chance('redis');

    it('should be able', (): void => {

        expect(1).to.be.instanceOf(1);
    });
});
