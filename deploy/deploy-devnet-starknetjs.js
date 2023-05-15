// starknet-devnet --seed 1933948612 --timeout 5000
import { Contract, Account, ec, json, stark, Provider, hash, uint256 } from "starknet";

// initialize provider
const provider = new Provider({ sequencer: { baseUrl:"http://127.0.0.1:5050"  } });
// initialize existing pre-deployed account 0 of Devnet
// Account #0
// Address: 0x7e00d496e324876bbc8531f2d9a82bf154d1a04a50218ee74cdd372f75a551a
// Public key: 0x7e52885445756b313ea16849145363ccb73fb4ab0440dbac333cf9d13de82b9
// Private key: 0xe3e70682c2094cac629f6fbed82c07cd

const admin_privateKey = "0xe3e70682c2094cac629f6fbed82c07cd";
const admin_starkKeyPair = ec.getKeyPair(admin_privateKey);
const admin_accountAddress = "0x7e00d496e324876bbc8531f2d9a82bf154d1a04a50218ee74cdd372f75a551a";
const admin_account = new Account(provider, admin_accountAddress, admin_starkKeyPair);

// Account #1
// Address: 0x69b49c2cc8b16e80e86bfc5b0614a59aa8c9b601569c7b80dde04d3f3151b79
// Public key: 0x175666e92f540a19eb24fa299ce04c23f3b75cb2d2332e3ff2021bf6d615fa5
// Private key: 0xf728b4fa42485e3a0a5d2f346baa9455

const test_privateKey = "0xf728b4fa42485e3a0a5d2f346baa9455";
const test_starkKeyPair = ec.getKeyPair(test_privateKey);
const test_accountAddress = "0x69b49c2cc8b16e80e86bfc5b0614a59aa8c9b601569c7b80dde04d3f3151b79";
const test_account = new Account(provider, test_accountAddress, test_starkKeyPair);

// starknet get_code --contract_address 0x49D36570D4E46F48E99674BD3FCC84644DDD6B96F7C741B1562B82F9E004DC7 --feeder_gateway_url http://localhost:5050 > output6.json

const faucetAddress = "0x49D36570D4E46F48E99674BD3FCC84644DDD6B96F7C741B1562B82F9E004DC7";

// read abi of faucet contract
const { abi: faucetAbi } = await provider.getClassAt(faucetAddress);
if (faucetAbi === undefined) { throw new Error("no abi.") };
const faucetContract = new Contract(faucetAbi, faucetAddress, provider);
console.log('faucet address is', faucetContract.address)

// faucetContract.connect(admin_account);


const admin_balance = await faucetContract.balanceOf(admin_account.address);
const test_balance = await faucetContract.balanceOf(test_account.address);
// console.log("Initial balance =", bal1.res.toString());

// Interactions with the contract with call & invoke
// const bal1 = await faucetContract.call("balanceOf");
// console.log("Initial balance =", bal1.res.toString());
console.log("Initial admin account balance =", uint256.uint256ToBN(admin_balance.balance).toString());
console.log("Initial test account balance =", uint256.uint256ToBN(test_balance.balance).toString());