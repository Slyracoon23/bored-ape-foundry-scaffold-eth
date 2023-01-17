import { Contract } from "components/contract";
import { Contracts } from "components/contracts";
import { Footer } from "components/footer";
import { Header } from "components/header";
import { Wallet } from "components/wallet";
import { AddressZero } from "core/constants";
import { Address } from "core/types";
import { useToggle } from "hooks";
import type { NextPage } from "next";
import Head from "next/head";
import { useState } from "react";
import React from 'react'
import {useRouter} from 'next/router'





const Apes: NextPage = () => {
  const router = useRouter()
  const {walletId} = router.query
  //console.log(walletId)
  const [activeContract, setActiveContract] = useState<Address>(AddressZero);
  const { state: isWalletOpen, toggle: toggleWallet } = useToggle(false);
  const walletButtonText = isWalletOpen ? "close wallet" : "open wallet";
  const contract_address = "0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D"
  
  //console.log(contract_address)
  const resetActiveContract = () => setActiveContract(AddressZero);

  //console.log(props)
  React.useEffect( () => {
    document.getElementById('result_nfts').innerHTML = 'Loading...'
    const apiKey = "7115d918-50fd-462c-b45d-87ae5a6d2c01"
    const address = "0xDBfD76AF2157Dc15eE4e57F3f942bB45Ba84aF24"
    
    let url = `https://api.nftport.xyz/v0/accounts/${address}?chain=ethereum&include=metadata&contract_address=${contract_address}`
    // let url = `https://api.nftport.xyz/v0/accounts/${walletId}?chain=ethereum&include=metadata`
    fetch(url, {
      method: "GET",
      headers: {
      "Content-Type": "application/json",
      "Authorization": apiKey
      },
    })
      .then(function(response) {
        // Parse the body as JSON
        return response.json();
      })
      .then(function(json) {
        // Render the parsed body
        const nfts = json['nfts']
        console.log(nfts)
        document.getElementById('result_nfts').innerHTML = ''
        nfts.forEach((nft) => {
          document.getElementById('result_nfts').innerHTML += `
                  <div class="col mx-2 my-3">
                        <div class="card shadow-sm">
                            <img src="${nft['cached_file_url']}" class="img-fluid" alt="NFT image">
                            
                            <div class="card-body">

                                <p class="card-text">
                                Bored Ape Yacht Club
                                <br/>
                                  #${nft['token_id']}

                                </p>
                                <p class="card-text"> 
                                 
                                <div class="d-flex justify-content-between align-items-center">
                                </div>                            
                            </div>
                        </div>
                    </div>
          `;
        })
      })
    })

    // <small class="text-muted text-truncate">${nft['description']}</small>

  return (
    <section className="text-black dark:text-white dark:bg-black min-h-screen max-h-screen flex flex-col overflow-hidden selection:bg-black selection:text-white dark:selection:bg-white dark:selection:text-black">
      <Head>
        <title>ApeMatcher</title>
        <link rel="icon" href="/favicon.ico" />
        <meta
          name="description"
          content="Blacksmith is an adaptive user interface for smart contract interaction."
        />
      </Head>
      <Header
        toggleWallet={toggleWallet}
        resetActiveContract={resetActiveContract}
        walletButtonText={walletButtonText}
      />
      <main className="bg-white dark:bg-black flex flex-col md:flex-row flex-grow overflow-y-auto overscroll-none">
        <section className="flex flex-col justify-content-center flex-grow bg-white dark:bg-black p-2 overflow-y-auto md:overscroll-none text-center">
          <h2 className="font-bold ">Select Your Apes</h2>
          <div id="result_nfts" className="flex flex-row flex-wrap">

          </div>
          <button className="btn border border-black dark:border-white mx-2 px-2 py-0.5 focus:italic focus:outline-none">Submit</button>
        </section>
        <Wallet open={isWalletOpen} />
      </main>
    </section>
  );
};

export default Apes;
