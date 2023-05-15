import { Account, ec, json, stark, Provider, hash } from "starknet";

const provider = new Provider({ sequencer: { baseUrl:"http://127.0.0.1:5050"  } });
const privateKey = "0x065faf7ed9e392cacfe4b518de3c1372a3be996de7e7a0f9c31fb49a9a0e47aa";
const starkKeyPair = ec.getKeyPair(privateKey);
const starkKeyPub = ec.getStarkKey(starkKeyPair);
const accountAddress = "0x76c7d726e3e3d2bb54c0cc4b8f4d5e112cbfdf235807c8e54eb0ecb007146f0";

const OZaccount = new Account(provider, accountAddress, starkKeyPair);

const OZaccountClassHash = "0x2794ce20e5f2ff0d40e632cb53845b9f4e526ebd8471983f7dbd355b721d5a";
// Calculate future address of the account
const OZaccountConstructorCallData = stark.compileCalldata({ publicKey: starkKeyPub });

const { transaction_hash, contract_address } = await OZaccount.deployAccount({
    classHash: OZaccountClassHash,
    constructorCalldata: OZaccountConstructorCallData,
    addressSalt: starkKeyPub
});

await provider.waitForTransaction(transaction_hash);
console.log('✅ New OpenZeppelin account created.\n   address =', contract_address);