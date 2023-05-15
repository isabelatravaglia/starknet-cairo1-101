import { Contract, Account, ec, json, stark, Provider, hash, uint256 } from "starknet";
import axios from "axios";
import fs from "fs";

// connect provider
// const provider = new Provider({ sequencer: { network: "goerli-alpha" } }); //Testnet
const provider = new Provider({ sequencer: { network: "http://127.0.0.1:5050" } })
// Connect the deployed faucet contract in Starknet-devnet
const faucetAddress = "0x49D36570D4E46F48E99674BD3FCC84644DDD6B96F7C741B1562B82F9E004DC7";
// read abi of Test contract
const compiledFaucet = json.parse(fs.readFileSync("./devnet_faucet_abi.json").toString("ascii"));
// const { abi: faucetAbi } = await provider.getClassAt(faucetAddress);
// if (faucetAbi === undefined) { throw new Error("no abi.") };
const faucetContract = new Contract(compiledFaucet, faucetAddress, provider);


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

// curl -X POST http://127.0.0.1:5050/mint -d '{"address":"0x04a093c37ab61065d001550089b1089922212c60b34e662bb14f2f91faee2979","amount":50000000000000000000,"lite":true}' -H "Content-Type:application/json"
// {"new_balance":50000000000000000000,"tx_hash":null,"unit":"wei"}

// fund account address before account creation
const { data: answer } = await axios.post('http://127.0.0.1:5050/mint', { "address": OZcontractAddress, "amount": 100_000_000_000_000, "lite": true }, { headers: { "Content-Type": "application/json" } });
console.log('Answer mint =', answer);

// 100_000_000_000_000
// setTimeout(function(){
    //     console.log("Executed after 10 seconds");
    // }, 10000);
    
//  Deploy account
const OZaccount = new Account(provider, OZcontractAddress, starkKeyPair);
console.log('OZAccount address', OZaccount.address);
    
// Connect account with the contract
// faucetContract.connect(OZaccount);

// const bal1 = await faucetContract.call("balanceOf");
const bal1 = await faucetContract.balanceOf(OZaccount.address);
const supply = await faucetContract.totalSupply();
console.log("account0 has a balance of :", uint256.uint256ToBN(bal1.balance).toString());
console.log("account0 has a balance of :", OZaccount.address);

// console.log("Initial balance =", bal1.res.toString());

const { transaction_hash, contract_address } = await OZaccount.deployAccount({
    classHash: OZaccountClassHash,
    constructorCalldata: OZaccountConstructorCallData,
    addressSalt: starkKeyPub
});

await provider.waitForTransaction(transaction_hash);
console.log('✅ New OpenZeppelin account created.\n   address =', contract_address);