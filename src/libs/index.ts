import {LibGenerateTestUserSig} from './lib-generate-test-usersig.min.js'

export function generateTestUserSig(sdkAppId: number, userId: string, sdkSecretKey: string): string {
    const generator = new LibGenerateTestUserSig(sdkAppId, sdkSecretKey, 604800)
    const {userSig} = generator.genTestUserSig(userId)
    return userSig;
}