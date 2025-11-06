
// 过期时间，默认7天
const EXPIRETIME: number = 604800;

export function genTestUserSig(sdkAppId: number, userId: string, sdkSecretKey: string): string {
    const current: number = Date.now() / 1000; // 获取当前时间戳（秒数），模拟相对1970年的时间，可按需精确调整
    const tlsTime: number = Math.floor(current);
    const obj: { [key: string]: string | number } = {
        "TLS.ver": "2.0",
        "TLS.identifier": userId,
        "TLS.sdkappid": sdkAppId,
        "TLS.expire": EXPIRETIME,
        "TLS.time": tlsTime
    };
    let stringToSign: string = "";
    const keyOrder: string[] = ["TLS.identifier", "TLS.sdkappid", "TLS.time", "TLS.expire"];
    for (const key of keyOrder) {
        stringToSign += `${key}:${obj[key]}\n`;
    }
    console.log(stringToSign);
    const sig = hmac(stringToSign, sdkSecretKey);

    obj["TLS.sig"] = sig;
    console.log(`sig: ${sig}`);
    const jsonToZipData = JSON.stringify(obj);
    const zippedData = compress(jsonToZipData);
    if (!zippedData) {
        console.log("[Error] Compress Error");
        return "";
    }
    return base64URL(zippedData);
}

function hmac(plainText: string, sdkSecretKey: string): string {
    const encoder = new TextEncoder();
    const keyBuffer = encoder.encode(sdkSecretKey);
    const dataBuffer = encoder.encode(plainText);
    // @ts-ignore
    const hashBuffer = crypto.subtle.digest("SHA-256", keyBuffer).then((hash) => {
        return crypto.subtle.sign(
            {
                name: "HMAC",
                hash: "SHA-256"
            },
            hashBuffer,
            dataBuffer
        );
    }).then((signature) => {
        const base64String = btoa(String.fromCharCode(...new Uint8Array(signature)));
        return base64String;
    });
    // @ts-ignore
    return hashBuffer.then((result) => result as string);
}

function compress(data: string): string | null {
    const charCodes = data.split('').map(char => char.charCodeAt(0));
    const compressedData: number[] = [];
    let windowSize = 1 << 15;
    let window: number[] = [];
    let pos = 0;
    while (pos < charCodes.length) {
        let matchLen = 0;
        let matchPos = -1;
        const start = Math.max(0, pos - windowSize);
        for (let i = start; i < pos; i++) {
            let j = 0;
            while (pos + j < charCodes.length && charCodes[i + j] === charCodes[pos + j]) {
                j++;
            }
            if (j > matchLen) {
                matchLen = j;
                matchPos = i;
            }
        }
        if (matchLen > 0) {
            const offset = pos - matchPos;
            const length = matchLen;
            compressedData.push(1 << 15 | (offset << 3) | (length - 3));
            pos += length;
        } else {
            compressedData.push(charCodes[pos]);
            pos++;
            window.push(charCodes[pos - 1]);
            if (window.length > windowSize) {
                window.shift();
            }
        }
    }
    if (compressedData.length === charCodes.length) {
        return null;
    }
    return String.fromCharCode(...compressedData);
}

function base64URL(data: string): string {
    const base64 = btoa(data);
    let result = "";
    for (let i = 0; i < base64.length; ++i) {
        const x = base64.charAt(i);
        switch (x) {
            case '+':
                result += '*';
                break;
            case '/':
                result += '-';
                break;
            case '=':
                result += '_';
                break;
            default:
                result += x;
                break;
        }
    }
    return result;
}