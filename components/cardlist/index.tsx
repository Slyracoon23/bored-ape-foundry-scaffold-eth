import { Address, ContractDetails } from "core/types";
import { useContracts } from "hooks";
import { List } from "lodash";
import React from 'react'
import { TemplateCard } from "components/card";




const CardList = ({data}) => {
  return (

    data.map((item, i) => {
    
    
    if (data.length != 0){
      return (
        <TemplateCard title={`BAYC`} description={item['description']} tokenid={item['token_id']} img={item['cached_file_url']} index={i}/>
  );
    

}}))}
  /* selected,  we will make this a state instead of prop */


export default CardList