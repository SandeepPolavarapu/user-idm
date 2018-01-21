pragma solidity ^0.4.1;

contract UserIdentityManagement {

   struct Account {
       address owner;
       string firstName;
       string lastName;
       string dateOfBirth;
       string phoneNumber;
       string gender;
       bool isLocked;
   }

   struct Proposal {
         uint proposalId;
         bool firstName;
         bool lastName;
         bool dateOfBirth;
         bool gender;
         bool phoneNumber;
         address sender;
         address reciever;
    }

    struct Grant {
       string grantId;
       string firstName;
       string lastName;
       string dateOfBirth;
       string phoneNumber;
       string gender;
       address sender;
       address reciever;
    }

   uint counter;
   mapping(address => Account) accounts;
   mapping(address => Proposal) proposals;
   mapping(address => Grant) grants;
   address owner;

   function UserIdentityManagement() public {
        owner = msg.sender;
   }

   function lock(address toLock) public returns (bool isLocked) {
       accounts[toLock].isLocked = true;
       return accounts[toLock].isLocked;
   }

   function unLock(address toLock) public returns (bool isLocked) {
       accounts[toLock].isLocked = false;
       return accounts[toLock].isLocked;
   }

   function sendProposal(address s, address r, bool fn, bool ln, bool dob, bool gn, bool ph) public {
        uint pid = getCounter();
        Proposal memory pr = Proposal({proposalId: pid, firstName:fn, lastName:ln, dateOfBirth:dob, gender:gn, phoneNumber:ph, sender:s, reciever:r});
        proposals.recievedProposals.push(pr);
        accounts[s].sentProposals.push(pr);
    }

   function getRecievedProposals(address r) public returns (Proposal[]) {
        return accounts[r].recievedProposals;
    }

    function getCounter() private returns(uint cnt) {
      return counter + 1;
    }
}
