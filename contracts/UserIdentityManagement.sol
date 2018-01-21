pragma solidity ^0.4.1;

contract UserIdentityManagement {

uint counter;
   struct Account {
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
       uint grantId;
       uint proposalId;
       address sender;
       address reciever;
       string firstName;
       string lastName;
       string dateOfBirth;
       string phoneNumber;
       string gender;
    }

   address owner;
   mapping(address => Account) citizens;
  // mapping(address => Proposal) proposals;
  // mapping(address => Grant) grants;

   function UserIdentityManagement() public {
        owner = msg.sender;
   }

   function lock(address toLock) returns (bool isLocked) {
       citizens[toLock].isLocked = true;
       return citizens[toLock].isLocked;
   }

   function unLock(address toLock) returns (bool isLocked) {
       citizens[toLock].isLocked = false;
       return citizens[toLock].isLocked;
   }

   Proposal[] proposals;
   function sendProposal(address s, address r, bool fn, bool ln, bool dob, bool gn, bool ph) public {

       Proposal memory pr = Proposal({proposalId: getCounter(), firstName:fn, lastName:ln, dateOfBirth:dob, gender:gn, phoneNumber:ph, sender:s, reciever:r});
        proposals.push(pr);
    }


    Grant[] grants;
    //Grant[] sentGrants;
    function sendGrant(address s, address r, uint pid, bool fn, bool ln, bool dob, bool gn, bool ph) public {

       Grant memory g = Grant({grantId:0, proposalId:0, sender:msg.sender, reciever:msg.sender, firstName:"", lastName:"", gender:"", phoneNumber:"",dateOfBirth:""});
        g.grantId=getCounter();
        g.proposalId=pid;
        g.sender=s;
        g.reciever =r;

        if (fn) {g.firstName = citizens[s].firstName;}
        if (ln) {g.lastName = citizens[s].lastName;}
        if (gn) {g.gender = citizens[s].gender;}
        if (ph) {g.phoneNumber = citizens[s].phoneNumber;}
        if (dob) {g.dateOfBirth = citizens[s].dateOfBirth;}
        grants.push(g);
    }


    uint[] requesterIndex;
    mapping (uint => address) requesterMapping;
    function getRequesterMapping(address requesterAddress, uint aId) public {

             requesterMapping[aId] = requesterAddress;
             requesterIndex.push(aId);
    }

    function kill() public {
        if ( msg.sender==owner) {
            selfdestruct(owner);
        }
    }

  function viewSentProposals(address s) public returns(uint[] proposalIds) {

     uint[] pIds;
      for (uint index = 0; index < proposals.length; index++) {
        if (proposals[index].sender == s) {
              pIds.push(proposals[index].proposalId);
        }
      }

      return pIds;

  }

  function viewReceivedProposals(address r) public returns(uint[] proposalIds) {
    uint[]  pIds;
    for (uint index = 0; index < proposals.length; index++) {
        if (proposals[index].reciever == r) {
              pIds.push(proposals[index].proposalId);
        }
      }
      return pIds;
 }

 function viewSentGrant(address s) public returns(uint[] grantIds) {

   uint[] gIds;
      for (uint index = 0; index < grants.length; index++) {
        if (grants[index].sender == s) {
              gIds.push(grants[index].grantId);
        }
      }
      return gIds;
 }

  function viewReceivedGrants(address r) public returns(uint[] grantIds) {
    uint[]  gIds;
    for (uint index = 0; index < grants.length; index++) {
        if (grants[index].reciever == r) {
              gIds.push(grants[index].grantId);
        }
      }
      return gIds;
 }

function getCounter() private returns(uint cnt) {
      return counter + 1;
    }

}
