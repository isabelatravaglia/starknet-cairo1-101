1- Setup the ENV
### Export ENV
``` bash
export STARKNET_NETWORK=alpha-goerli
export STARKNET_WALLET=starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount
```
2- Start starknet-devnet
``` bash
starknet-devnet
```

<!-- starknet-devnet seed 1933948612 --timeout 5000 -->

3- ### Setup accounts
```bash
starknet new_account --account admin --gateway_url http://localhost:5050 --feeder_gateway_url http://localhost:5050
starknet new_account --account test --gateway_url http://localhost:5050 --feeder_gateway_url http://localhost:5050
```

4- Get the addresses from the two accounts created above and add fund to it.

On starknet-devnet there is an ERC20 contract that can be used as a faucet:
Hex address: 0x49D36570D4E46F48E99674BD3FCC84644DDD6B96F7C741B1562B82F9E004DC7
Felt address: 2087021424722619777119509474943472645767659996348769578120564519014510906823
Note: to convert the hex to felt address you can use the hex_to_felt function on utils.py.

To fund the accounts, we need to use the 'starknet invoke' command. But to do that, we need a couple of things:
    a) The ERC20 ABI. The ABI is needed for 2 reasons: to figure out which function we need to invoke to fund our accounts, and to be used as a mandatory argument on the 'starknet invoke' command.
    b) Find out which function of the ERC20 to use (for a faucet could be 'transfer' or 'mint') by inspecting the ABI and use the right arguments of the function;
    
Ok, so how do we get the ERC20 ABI? That is a great question! 
I used the commands 'starknet get_full_contrat' and 'starknet get_code' to try getting the contract ABI and figure out its entrypoints (functions), but it didn't work. By luck, I ended up finding it out running 'starknet invoke --address 0x49D36570D4E46F48E99674BD3FCC84644DDD6B96F7C741B1562B82F9E004DC7 --function mint --inputs ...'.
Since the mint function doesn't exist in the ERC20 contract, the command failed and the error log disclosed the class hash: 
"Entry point 0x2f0b3c5710379609eb5495f1ecd348cb28167711b73609fe565a72734550354 not found in contract with class hash 0x2760f25d5a4fb2bdde5f561fd0b44a3dee78c28903577d37d669939d97036a0."
The class hash allows us to get the contract ABI with 'starknet get_class_by_hash --class_hash 0x2760f25d5a4fb2bdde5f561fd0b44a3dee78c28903577d37d669939d97036a0 > ./output.txt '
The output.txt file contains the ABI, which you can copy and create a devnet_faucet_abi.json file.

Now that we have the ABI, we can inspect it and figure out which function we should call to fund our accounts. If we look for a 'transfer' function, we will find one that requires the following inputs: 
    ""inputs": [
                {
                    "name": "recipient",
                    "type": "felt"
                },
                {
                    "name": "amount",
                    "type": "Uint256"
                }
            ],
    "
The 'recipient' argument is of type felt, hence we need to convert our hex-formatted adresses to felt-formatted addresses. We can do that by using the 'hex_to_felt' function on the utils.py file.
For example, the admin account address is 0xad1a07da5743404a890a85a588603fadbd087e65558d102796dab928c1998b, and when invoking het_to_felt we get the felt value:

``` bash
python -i utils.py
hex_to_felt('0xad1a07da5743404a890a85a588603fadbd087e65558d102796dab928c1998b')
>>> 305844199325281090009142332831891203497464880628448605769360567526746069387
```

Now we have everything needed to invoke the transfer function on the ERC20 and fund our accounts:

``` bash
starknet invoke --gateway_url http://localhost:5050 --feeder_gateway_url http://localhost:5050 --account 0x4fa3ee3ba28b989ccb06672b9f785fc4e432bba0a5813ebe4c71358ee0eecc6 --address 0x49D36570D4E46F48E99674BD3FCC84644DDD6B96F7C741B1562B82F9E004DC7 --abi ./devnet_faucet_abi.json --function transfer --inputs 1604567861735041507860684948580053764874385296358769332509196826907753658708 100000000000000 0

starknet invoke --gateway_url http://localhost:5050 --feeder_gateway_url http://localhost:5050 --address 0x49D36570D4E46F48E99674BD3FCC84644DDD6B96F7C741B1562B82F9E004DC7 --abi ./devnet_faucet_abi.json --function transfer --inputs 2525673291533918433689342096142189896551200429218990741949268828192389832830 100000000000000 0
```

The above solution doesn't work because we need to have a deployed and funded account to invoke the transfer function. Starknet-devnet creates funded accounts when initializes, hence we can get one of those accounts, add it to the starknet_open_zeppelin_accounts.json file and use it as the account to invoke the transfer.

``` bash
starknet invoke --gateway_url http://localhost:5050 --feeder_gateway_url http://localhost:5050 --account devnet --address 0x49D36570D4E46F48E99674BD3FCC84644DDD6B96F7C741B1562B82F9E004DC7 --abi ./devnet_faucet_abi.json --function transfer --inputs 1604567861735041507860684948580053764874385296358769332509196826907753658708 100000000000000000000 0
```

5- With the accounts funded, we can now deploy them:
``` bash
starknet deploy_account --account admin --gateway_url http://localhost:5050 --feeder_gateway_url http://localhost:5050

starknet deploy_account --account test --gateway_url http://localhost:5050 --feeder_gateway_url http://localhost:5050
```

Original class hash> acquired by log errors
0x2760f25d5a4fb2bdde5f561fd0b44a3dee78c28903577d37d669939d97036a0

Class hash using
starknet get_class_hash_at --contract_address 0x49D36570D4E46F48E99674BD3FCC84644DDD6B96F7C741B1562B82F9E004DC7

0xd0e183745e9dae3e4e78a8ffedcce0903fc4900beace4e0abf192d4c202da3