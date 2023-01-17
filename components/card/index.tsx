import { Address, ContractDetails } from "core/types";
import { useContracts } from "hooks";
import React from 'react'
import { State } from "swr";

type Props = {
    title: string;
    description: string;
    img: string;
    selected?: boolean;
    tokenid: string
    key: number
    onClick: any
    
};

export const TemplateCard = ({
  title,
  description,
  img,
  tokenid,
  key,
  onClick
  /* selected,  we will make this a state instead of prop */
}: Props) => {

  const [selected, setSelected] = React.useState(false); // Added state

  // Added handler
  const handleClick = () => {
    setSelected(!selected);
    
    
  };
  const handleStateChange = () => {
    if(!selected){
      const selBool = true
      onClick(title, tokenid, selBool)
      }else{
      const selBool = false
        onClick(title, tokenid, selBool)
      }
  }

   

  return (
    <div className={`mx-2 my-3`} onClick={handleStateChange}>
      <div className={`card ${selected ? "card-selected": ""}` } onClick={handleClick}>
          <img className="img-fluid" alt="NFT Image" src={img}></img>
          <div className="card-body">
            <p>
              <div className="">{title}</div>
              <div className="">{tokenid}</div>
            </p>
            <div className="d-flex justify-content-between align-items-center">
                <small className="text-muted text-truncate">{description}</small>
            </div> 
          </div>
      </div>
    </div>
  );
};