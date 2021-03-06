import { Component, HostListener, NgZone } from '@angular/core';
const Web3 = require('web3');
const contract = require('truffle-contract');
const idmArtifacts = require('../../../build/contracts/UserIdentityManagement.json');

declare var window: any;
declare var require: any;

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent {

  toaccount:string;
  UserIdentityManager = contract(idmArtifacts);
  constructor() { }

  ngOnInit() {
    this.checkAndInstantiateWeb3();
    this.onReady();
  }

  account: any;
  accounts: any;
  web3: any;
  status: string;

  setStatus = message => {
    this.status = message;
    //alert(message);
  };

  onReady = () => {

    this.UserIdentityManager.setProvider(this.web3.currentProvider);
    // Get the initial account balance so it can be displayed.
    this.web3.eth.getAccounts((err, accs) => {
      if (err != null) {
        alert('There was an error fetching your accounts.');
        return;
      }

      if (accs.length === 0) {
        alert(
          'Couldn\'t get any accounts! Make sure your Ethereum client is configured correctly.'
        );
        return;
      }
      this.accounts = accs;
      this.account = this.accounts[0];
      //this.setStatus("Success: Account is "+this.account);
      // This is run from window:load and ZoneJS is not aware of it we
      // need to use _ngZone.run() so that the UI updates on promise resolution
      //this._ngZone.run(() =>
        //this.refreshBalance()
      //);
    });
  };

  checkAndInstantiateWeb3 = () => {
    // Checking if Web3 has been injected by the browser (Mist/MetaMask)
    if (typeof window.web3 !== 'undefined') {
      console.warn(
        'Using web3 detected from external source. If you find that your accounts don\'t appear or you have 0 MetaCoin, ensure you\'ve configured that source properly. If using MetaMask, see the following link. Feel free to delete this warning. :) http://truffleframework.com/tutorials/truffle-and-metamask'
      );
      // Use Mist/MetaMask's provider
      this.web3 = new Web3(window.web3.currentProvider);
    } else {
      console.warn(
        'No web3 detected. Falling back to http://localhost:7545. You should remove this fallback when you deploy live, as it\'s inherently insecure. Consider switching to Metamask for development. More info here: http://truffleframework.com/tutorials/truffle-and-metamask'
      );
      // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
      this.web3 = new Web3(
        new Web3.providers.HttpProvider('http://localhost:7545')
      );
    }
  };


  sendProposal = () => {
    this.checkAndInstantiateWeb3();
    //alert(this.toaccount);
      let meta;
      this.UserIdentityManager
        .deployed()
        .then(instance => {
        meta = instance;
        // Execute adopt as a transaction by sending account
        return meta.sendProposal("0x627306090abaB3A6e1400e9345bC60c78a8BEf57", this.toaccount, true, true, true, true, true, {
          from: "0x627306090abaB3A6e1400e9345bC60c78a8BEf57"
        });
      })
      .then(value => {
        this.setStatus('Transaction complete!'+value);
      })
      .catch(e => {
        console.log(e.message);
        this.setStatus('Error .');
      });

  }

}
