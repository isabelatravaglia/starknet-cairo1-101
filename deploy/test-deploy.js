import { Account, ec, json, stark, Provider, hash } from "starknet";
import axios from "axios";

// connect provider
const provider = new Provider({ sequencer: { network: "http://127.0.0.1:5050" } });

// new Open Zeppelin account v0.5.1 :
    // Generate public and private key pair.
const privateKey = stark.randomAddress();
console.log('New OZ account :\nprivateKey=', privateKey);
const starkKeyPair = ec.getKeyPair(privateKey);
const starkKeyPub = ec.getStarkKey(starkKeyPair);
console.log('publicKey=', starkKeyPub);

const OZaccountClassHash = "0x2794ce20e5f2ff0d40e632cb53845b9f4e526ebd8471983f7dbd355b721d5a";
// Calculate future address of the account
const OZaccountConstructorCallData = stark.compileCalldata({ publicKey: starkKeyPub });
const OZcontractAddress = hash.calculateContractAddressFromHash(
    starkKeyPub,
    OZaccountClassHash,
    OZaccountConstructorCallData,
    0
);
console.log('Precalculated account address=', OZcontractAddress);

const { data: answer } = await axios.post('http://127.0.0.1:5050/mint', { "address": OZcontractAddress, "amount": 100_000_000_000_000, "lite": true }, { headers: { "Content-Type": "application/json" } });
console.log('Answer mint =', answer);

const OZaccount = new Account(provider, OZcontractAddress, starkKeyPair);

const { transaction_hash, contract_address } = await OZaccount.deployAccount({
    classHash: OZaccountClassHash,
    constructorCalldata: OZaccountConstructorCallData,
    addressSalt: starkKeyPub
});

await provider.waitForTransaction(transaction_hash);
console.log('✅ New OpenZeppelin account created.\n   address =', contract_address);