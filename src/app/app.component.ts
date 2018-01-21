import { Component, HostListener, NgZone } from '@angular/core';
const Web3 = require('web3');
const contract = require('truffle-contract');
const adoptionArtifacts = require('../../build/contracts/Adoption.json');

declare var window: any;
declare var require: any;

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'Identity Management';

  Adoption = contract(adoptionArtifacts);

  // TODO add proper types these variables
  account: any;
  accounts: any;
  web3: any;
  status: string;

  username:string;
  password:string;
  isLogged: boolean;
  constructor(private _ngZone: NgZone) {

  }

  @HostListener('window:load')
  windowLoaded() {
    this.checkAndInstantiateWeb3();
    this.onReady();
  }

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

  onReady = () => {
    // Bootstrap the Adoption abstraction for Use.
    this.isLogged = false;
    this.Adoption.setProvider(this.web3.currentProvider);
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

  setStatus = message => {
    this.status = message;
    //alert(message);
  };

  handleLogin = () => {
    this.isLogged = true;
  }

  handleAdopt = () => {
    var petId = "2";        
      let meta;
      this.Adoption
        .deployed()
        .then(instance => {
        meta = instance;
        // Execute adopt as a transaction by sending account
        return meta.adopt(petId, {
          from: this.account
        });        
      })
      .then(value => {
        this.setStatus('Transaction complete!'+value);
      })
      .catch(e => {    
        console.log(e.message);
        this.setStatus('Error adopting dog; see log.');
      });
    
  }

};