// SPDX-License-Identifier: MIT
pragma solidity ^ 0.8.0;
contract crowdfunding{
    mapping (address=> uint256) public contributers;
    address public manager;
    uint256 public minimumContribution;
    uint256 public deadline;
    uint256 public target;
    uint256 public  rised_Amount;
    uint256 public noOfContributors;
struct request{
    string discription;
    uint256 noOfVoters;
    address receipent;
    uint256 value;
    bool completed;
    mapping(address=> bool) voters;
}
mapping (uint256=>request) public requests;
uint256 public noOfRequest;
    constructor(uint256 _target ,uint256 _deadline )  {
            target=_target;
            deadline=block.timestamp+_deadline; //3600
            minimumContribution = 100 wei;
            manager=msg.sender;
    }
    function sendEth() public payable{
    require(block.timestamp< deadline ,"deadline has been passed");
    require(minimumContribution<=msg.value ,"contribution is not minimum yet");
      if(contributers[msg.sender]==0 ){
          noOfContributors++;
          contributers[msg.sender]+=msg.value;
          rised_Amount+=msg.value;
      }
    }
    function GetContractBalance() public view returns(uint256){
        return address(this).balance;
    }
    function refund() public {
        require(block.timestamp> deadline && rised_Amount<target," you are not aligible");
        require(contributers[msg.sender]>0 , " you cant contribute" );
    
        address  payable user=payable(msg.sender);
        user.transfer(contributers[msg.sender]);
        contributers[msg.sender]=0;
   }
   modifier onlymanager{
       require(manager==msg.sender , "only manager can call this function");
        _;
   }
   function createRequest( string memory _discription , address payable _receipent , uint256 _value ) public{
       request storage newRequest  = requests[noOfRequest];
       noOfRequest++;
    newRequest.discription=_discription;
    newRequest.receipent=_receipent;
    newRequest.value= _value;
    newRequest.completed=false;
    newRequest.noOfVoters=0;
   }
  function voteRequest( uint256 _RequestNo) public{
     require(contributers[msg.sender]>0 , " you cant contribute" ); 
      request storage ThisRequest  = requests[_RequestNo];
      require(ThisRequest.voters[msg.sender]==true );    
               ThisRequest.noOfVoters++;
  }
  function makeRequest( uint _RequestNo) public onlymanager{
   require(rised_Amount> target ,"rised amount is not greater than target");
   request storage ThisRequest  = requests[_RequestNo];
   require(ThisRequest.completed==false ,"the request has been completed" );
   require(ThisRequest.noOfVoters > noOfContributors," majority does not support");
  payable(msg.sender).transfer(1 ether);
                 ThisRequest.completed==true;
  }
}