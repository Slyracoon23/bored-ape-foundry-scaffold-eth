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
import { TemplateCard } from "components/card";



const Kennel: NextPage = () => {
  const router = useRouter()
  const {walletId} = router.query
  const [activeContract, setActiveContract] = useState<Address>(AddressZero);
  const { state: isWalletOpen, toggle: toggleWallet } = useToggle(false);
  const walletButtonText = isWalletOpen ? "close wallet" : "open wallet";
  const contract_address = ["0xba30E5F9Bb24caa003E9f2f0497Ad287FDF95623"]
  //console.log(contract_address)
  //const [data, setData] = useState([]);
  const [kcData, setKcData] = useState([]);
  const [userSelectData, setUserSelectData] = useState([]);
  const resetActiveContract = () => setActiveContract(AddressZero);
  //console.log(props)
  React.useEffect(() => {
    const apiKey = "7115d918-50fd-462c-b45d-87ae5a6d2c01"
    
    // let url = `https://api.nftport.xyz/v0/accounts/${walletId}?chain=ethereum&include=metadata`
    let url = `https://api.nftport.xyz/v0/accounts/${walletId}?chain=ethereum&include=metadata&contract_address=${contract_address[0]}`
    // let url2 = `https://api.nftport.xyz/v0/accounts/${walletId}?chain=ethereum&include=metadata&contract_address=${contract_address[1]}`
    fetch(url, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        "Authorization": apiKey
      }
    })
      .then(response => response.json())
      .then(result => setKcData(result.nfts || []))
    // setTimeout(() =>{
    //   fetch(url2, {
    //     method: "GET",
    //     headers: {
    //       "Content-Type": "application/json",
    //       "Authorization": apiKey
    //     }
    //   })
    //     .then(response => response.json())
    //     .then(result => setMaycData(result.nfts || []))

    // }, 2000)
      
      
    
    
  }, [])

  
  const handleClickedData = (title, tokenid, selectBool) =>{
    if (selectBool){
      const item = {tokenName: title, tokenId: tokenid}
      setUserSelectData((prevArr) => ([...prevArr, item]))
    }else{
      for(let i = 0; i<userSelectData.length; i++){
        if(userSelectData[i].tokenName == title && userSelectData[i].tokenId == tokenid){
          let newArr = [...userSelectData]
          // setUserSelectData(newArr)
          newArr.splice(i, 1)
          setUserSelectData(newArr)
          //console.log(userSelectData)

          
        }
      }
      

      }
    }

  const items = kcData.map((item, i) => {
    
    if (kcData.length != 0){
      return (
        <TemplateCard onClick={handleClickedData} title={`KC`} description={item['description']} tokenid={item['token_id']} img={item['cached_file_url']} key={i}/>
  
      );
      }

  })
  
  //console.log(items)
  console.log(userSelectData)
  console.log(kcData)
  // console.log(items)
  console.log(userSelectData)

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
        <section id="display-center" className="flex flex-col flex-grow bg-white dark:bg-black p-2 overflow-y-auto md:overscroll-none">
        <h2 className="font-bold text-center">Select Your Kennel</h2>
        <div id="result_nfts" className="flex flex-row flex-wrap">
          {items}
          </div>
          <button  className="btn border border-black dark:border-white mx-2 px-2 py-0.5 focus:italic focus:outline-none">Submit</button>
        </section>
        <Wallet open={isWalletOpen} />
      </main>
    </section>
  );
};

export default Kennel;
