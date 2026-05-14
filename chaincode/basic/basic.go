package main

import (
    "encoding/json"
    "fmt"

    "github.com/hyperledger/fabric-contract-api-go/contractapi"
)

type SmartContract struct {
    contractapi.Contract
}

type Asset struct {
    ID    string `json:"id"`
    Owner string `json:"owner"`
    Value int    `json:"value"`
}

func (s *SmartContract) InitLedger(ctx contractapi.TransactionContextInterface) error {
    assets := []Asset{
        {ID: "asset1", Owner: "Alice", Value: 100},
        {ID: "asset2", Owner: "Bob", Value: 200},
    }

    for _, asset := range assets {
        data, _ := json.Marshal(asset)
        err := ctx.GetStub().PutState(asset.ID, data)
        if err != nil {
            return err
        }
    }

    return nil
}

func (s *SmartContract) CreateAsset(
    ctx contractapi.TransactionContextInterface,
    id string,
    owner string,
    value int,
) error {

    asset := Asset{
        ID:    id,
        Owner: owner,
        Value: value,
    }

    data, _ := json.Marshal(asset)

    return ctx.GetStub().PutState(id, data)
}

func (s *SmartContract) ReadAsset(
    ctx contractapi.TransactionContextInterface,
    id string,
) (*Asset, error) {

    data, err := ctx.GetStub().GetState(id)

    if err != nil {
        return nil, err
    }

    if data == nil {
        return nil, fmt.Errorf("asset not found")
    }

    var asset Asset
    json.Unmarshal(data, &asset)

    return &asset, nil
}

func main() {
    chaincode, err := contractapi.NewChaincode(new(SmartContract))

    if err != nil {
        panic(err.Error())
    }

    if err := chaincode.Start(); err != nil {
        panic(err.Error())
    }
}