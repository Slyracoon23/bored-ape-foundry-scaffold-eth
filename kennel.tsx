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



const Kennel: NextPage = () => {
  const router = useRouter()
  const {walletId} = router.query
  const [activeContract, setActiveContract] = useState<Address>(AddressZero);
  const { state: isWalletOpen, toggle: toggleWallet } = useToggle(false);
  const walletButtonText = isWalletOpen ? "close wallet" : "open wallet";
  const contract_address = ["0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D", "0xDBfD76AF2157Dc15eE4e57F3f942bB45Ba84aF24"]
  //console.log(contract_address)
  //const [data, setData] = useState([]);
  const [baycData, setBaycData] = useState([]);
  const [maycData, setMaycData] = useState([]);
  const [userSelectData, setUserSelectData] = useState([]);
  const resetActiveContract = () => setActiveContract(AddressZero);
  //console.log(props)
  React.useEffect(() => {
    const apiKey = "7115d918-50fd-462c-b45d-87ae5a6d2c01"
    
    // let url = `https://api.nftport.xyz/v0/accounts/${walletId}?chain=ethereum&include=metadata`
    let url = `https://api.nftport.xyz/v0/accounts/${walletId}?chain=ethereum&include=metadata&contract_address=${contract_address[0]}`
    let url2 = `https://api.nftport.xyz/v0/accounts/${walletId}?chain=ethereum&include=metadata&contract_address=${contract_address[1]}`
    fetch(url, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        "Authorization": apiKey
      }
    })
      .then(response => response.json())
      .then(result => setBaycData(result.nfts || []))
    setTimeout(() =>{
      fetch(url2, {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
          "Authorization": apiKey
        }
      })
        .then(response => response.json())
        .then(result => setMaycData(result.nfts || []))

    }, 2000)
      
      
    
    
  }, [])

  
  

  const items = baycData.map((item, i) => {
    
    if (baycData.length != 0){
      return (
        <div className="mx-2 my-3" onClick={()=>setUserSelectData(oldArray => [...oldArray, item])}>
          <div className="card ">
            <img src={item['cached_file_url']} alt="NFT image" />
  
            <div className="card-body">
              <p className="card-text">
                {item['name']}
              </p>
              <div className="justify-content-between align-items-center">
                <small>${item['description']}</small>
              </div>
            </div>
          </div>
        </div>
  
      );
      }

  })
  const items2 = maycData.map((item, i) => {
    
    if (maycData.length != 0){
      return (
        <div className="mx-2 my-3" onClick={()=>setUserSelectData(oldArray => [...oldArray, item])}>
          <div className="card ">
            <img src={item['cached_file_url']} alt="NFT image" />
  
            <div className="card-body">
              <p className="card-text">
                {item['name']}
              </p>
              <div className="justify-content-between align-items-center">
                <small>${item['description']}</small>
              </div>
            </div>
          </div>
        </div>
  
      );
      }

  })
  //console.log(items)
  console.log(userSelectData)
  console.log(baycData)
  console.log(maycData)
  // console.log(items)
  console.log(userSelectData)

  return (
    <section className="text-black dark:text-white dark:bg-black min-h-screen max-h-screen flex flex-col overflow-hidden selection:bg-black selection:text-white dark:selection:bg-white dark:selection:text-black">
      <Head>
        <title>Blacksmith</title>
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
        <section className="flex flex-col flex-grow bg-white dark:bg-black p-2 overflow-y-auto md:overscroll-none">
        <h2 className="font-bold text-center">Select Your Kennel</h2>
        <div id="result_nfts" className="flex flex-row flex-wrap">
          {items}
          {items2}
          </div>
          <button  className="btn border border-black dark:border-white mx-2 px-2 py-0.5 focus:italic focus:outline-none">Submit</button>
        </section>
        <Wallet open={isWalletOpen} />
      </main>
    </section>
  );
};

export default Kennel;
