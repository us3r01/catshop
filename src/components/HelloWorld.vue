<template>
    <div>
        <v-content>
            <v-container>
                <v-spacer/>
                <v-btn @click="getWeb3">
                    Connect to MetaMask
                </v-btn>
                {{ this.accounts ? this.accounts[0] : "" }}
                <v-row class="text-center">
                    <v-col cols="12">
                        <div class="text-left">
                            <h1 class="text-left">Adopt a Kitten</h1>
                            <v-btn @click="getCats" class="mt-5" color="primary">
                                Update Cats
                            </v-btn>
                            <br>
                            <div class="text-left">
                            </div>
                        </div>
                    </v-col>
                    <v-row>
                        <v-col cols="12">
                        </v-col>
                    </v-row>
                    <br>
                    <v-row>
                        <v-col cols="12" class="text-center mb-5" md="4" v-for="item in cats" :key="item.image">
                            <v-card class="mx-auto" height="auto" width="auto" hover>
                                <v-card-title>
                                    {{item.name}}
                                </v-card-title>
                                <v-card-subtitle class="text-left">
                                    Breed: {{item.breed}}<br> Age: {{item.age}} <br> Sex: {{item.sex}}
                                </v-card-subtitle>
                                <v-card-text>
                                    <v-img height="350" width="350" :src="item.photo_url">
                                    </v-img>
                                </v-card-text>
                                <v-btn text :color="`${item.adopted ? 'red' : 'green'}`" dark>
                                    {{item.adopted ? 'adopted' : 'For adoption'}}
                                </v-btn>
                                <v-card-actions class="text-left">
                                    <v-btn :disabled="item.adopted" @click="adopt(item.id)" class="text-left">
                                        Adopt!
                                    </v-btn>
                                </v-card-actions>
                            </v-card>
                        </v-col>
                    </v-row>
                    <v-col class="mb-4">
                    </v-col>
                </v-row>
            </v-container>
        </v-content>
    
    </div>
</template>

<script>
import Web3 from 'web3';
import CatShop from "../../build/contracts/CatShop.json"
export default {
    name: 'HelloWorld',
    data: () => ({
        accounts: "",
        balance: null,
        instance: null,
        contract: null,
        name: '',
        url_foto: '',
        dialog: false,
        cats: []
    }),
    methods: {
        async getWeb3() {
            // eslint-disable-next-line no-undef
            await ethereum.enable();
            // eslint-disable-next-line no-undef
            const instance = new Web3(ethereum);
            this.instance = instance;
            this.accounts = await instance.eth.getAccounts();
            // eslint-disable-next-line no-undef
            ethereum.on('accountsChanged', function(accounts) {
                this.accounts = accounts;
                alert("Recarga la ventana, para ver tu nueva cuenta")
            })
            // Crear instancia del contract 
            const networkId = await instance.eth.net.getId();
            const deployedNetwork = CatShop.networks[networkId];
            const contract = new instance.eth.Contract(
                CatShop.abi,
                deployedNetwork && deployedNetwork.address,
            );
            this.contract = contract;
        },
        async getCats() {
            this.cats = [];
            let res = await this.contract.methods.n_cats().call();
            for (let i = 0; i < res; i++) {
                let newCat = await this.contract.methods.allCats(i).call();
                let object_aux = {
                    color: newCat.color,
                    breed: newCat.breed,
                    age: newCat.age,
                    name: newCat.name,
                    sex: newCat.sex,
                    photo_url: newCat.photo_url,
                    id: newCat.id,
                    adopter: newCat.adopter,
                    adopted: newCat.adopted,
                }
                this.cats.push(object_aux);
                console.log(newCat);
            }
        },
        async adopt(id) {
            await this.contract.methods.adoptCat(id).send({ from: this.accounts[0] });
        }
    },
    computed: {
        currentAccount() {
            return this.accounts;
        }
    }
}
</script>