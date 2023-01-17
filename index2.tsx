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
import Link from 'next/link'

const Home: NextPage = () => {
  const [activeContract, setActiveContract] = useState<Address>(AddressZero);
  const { state: isWalletOpen, toggle: toggleWallet } = useToggle(false);
  const walletButtonText = isWalletOpen ? "close wallet" : "open wallet";

  const resetActiveContract = () => setActiveContract(AddressZero);

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
        
        <section className="flex flex-col flex-grow bg-white dark:bg-black p-2 overflow-y-auto md:overscroll-none text-center">
          <h2 className="font-bold ">Select Which Contract</h2>
          <div className="my-3">
            
            {/* <Link className="border border-black dark:border-white mx-2 px-2 py-0.5 focus:italic focus:outline-none" href="/apes">Apes
            </Link> */}
            <Link className="border border-black dark:border-white mx-2 px-2 py-0.5 focus:italic focus:outline-none" href={{
              pathname:"/apes", 
              query: {
                walletId: "0xDBfD76AF2157Dc15eE4e57F3f942bB45Ba84aF24"
                }
              }}>
                Apes
            </Link>
            {/* <Link className="border border-black dark:border-white mx-2 px-2 py-0.5 focus:italic focus:outline-none" href="/kennel">Kennel Club
            </Link> */}
            <Link className="border border-black dark:border-white mx-2 px-2 py-0.5 focus:italic focus:outline-none" href={{
              pathname:"/kennel", 
              query: {
                walletId: "0xDBfD76AF2157Dc15eE4e57F3f942bB45Ba84aF24"
                }
              }}>
                Kennel Club
            </Link>

          </div>
          
          

        </section>
        <Wallet open={isWalletOpen} />
      </main>
    </section>
  );
};

export default Home;
