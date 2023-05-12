import {
    ec,
    Account,
    SequencerProvider
  } from "starknet";
  
  import * as dotenv from "dotenv";
  dotenv.config();
  
  // initialize provider
  // const provider = new Provider({ sequencer: { baseUrl:"goerli-alpha"  } });
  // STARKNET_PROVIDER_BASE_URL=https://alpha4.starknet.io
  const provider = process.env.STARKNET_PROVIDER_BASE_URL === undefined ?
    defaultProvider :
    new SequencerProvider({ baseUrl: process.env.STARKNET_PROVIDER_BASE_URL });
  // initialize existing account
  const privateKey = process.env.ARGENTX_ACCOUNT_PRIVKEY;
  const starkKeyPair = ec.getKeyPair(privateKey);
  const accountAddress = "0x06241600436f1D700Ec6cE51E0E12Ff16688f4A59706F217F25B5a476b7f6A01";
  
  const account = new Account(provider, accountAddress, starkKeyPair);

// Declare compiled contracts
// Deploy compiled contracts
//   Need the contracts class hash
// 