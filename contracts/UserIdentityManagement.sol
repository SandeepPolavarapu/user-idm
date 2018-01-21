pragma solidity ^0.4.1;

contract UserIdentityManagement {

   struct Citizen {
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
         address toAddress;
    }

    struct Grant {
       string proposalId;
       string firstName;
       string lastName;
       string dateOfBirth;
       string phoneNumber;
       string gender;
    }

   address owner;
   mapping(address => Citizen) citizens;
   mapping(address => Proposal) proposals;
   mapping(address => Grant) grants;

   function MyIdentity() public {
        owner = msg.sender;
   }

   function authenticate(address toVerify) returns (address isAuthenticated) {

      // Authenticate Logic
      if (owner==msg.sender || citizens[toVerify].isLocked) {
          return toVerify;
      }
      return toVerify;
   }

   function lock(address toLock) returns (bool isLocked) {
       citizens[toLock].isLocked = true;
       return citizens[toLock].isLocked;
   }

   function unLock(address toLock) returns (bool isLocked) {
       citizens[toLock].isLocked = false;
       return citizens[toLock].isLocked;
   }

   Proposal[] recievedProposals;
   function sendProposal(address receiverAddress) public {
        proposals[receiverAddress].firstName = true;
        proposals[receiverAddress].lastName = false;
        proposals[receiverAddress].dateOfBirth = true;
        proposals[receiverAddress].gender = false;
        proposals[receiverAddress].phoneNumber = false;
        proposals[receiverAddress].toAddress = receiverAddress;
        proposals[receiverAddress].proposalId = proposals[receiverAddress].proposalId+1;

        recievedProposals.push(proposals[receiverAddress]);
    }


    Grant[] receivedGrants;
    uint[] sentProposalIds;
    function sendGrant(Proposal requester) public {
        address requesterAddress = requester.toAddress;

        if (requester.firstName) {grants[requesterAddress].firstName = citizens[requesterAddress].firstName;}
        if (requester.lastName) {grants[requesterAddress].lastName = citizens[requesterAddress].lastName;}
        if (requester.gender) {grants[requesterAddress].gender = citizens[requesterAddress].gender;}
        if (requester.phoneNumber) {grants[requesterAddress].phoneNumber = citizens[requesterAddress].phoneNumber;}
        if (requester.dateOfBirth) {grants[requesterAddress].dateOfBirth = citizens[requesterAddress].dateOfBirth;}
        // grants[requestAddress].proposalId =requester.proposalId;


        receivedGrants.push(grants[requesterAddress]);
        sentProposalIds.push(requester.proposalId);
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

    uint expirationTime;
    function getExpirationTime() public {
        uint currentTime = 10;
        expirationTime = currentTime + 10;
    }

  function viewSentProposals(address addOfLoggedInUser) public returns(uint[] proposalIds) {
     return sentProposalIds;
  }

  function viewReceivedProposals(address addOfLoggedInUser) public returns(uint[] receivedProposalIds) {
    // receivedProposalIds.push(recievedProposals[addOfLoggedInUser].proposalId);
 }

 function viewSentGrant(address addOfLoggedInUser) public returns(uint[]  viewSentGrantIds){

 }

 function viewReceivedGrant(address addOfLoggedInUser) public returns(uint[]  viewReceivedGrantIds){

 }
}
