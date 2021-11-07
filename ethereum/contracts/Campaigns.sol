pragma solidity >=0.4.17 <0.9.0;

contract Campaigns 
{
    uint public campaigncount=0;
    struct Campaign 
    {
        uint campaignid;
        string description;
        string typeofcampaign;
        string targetcity;
        uint minimumcontribution;
        address managerid;
        uint priority;
        address approvedby;
        string proposalhash;
        uint [] requestlist;
        mapping(address => bool)backers;
        address [] backerslist;
        uint backerscount;
        uint totalmoney;
    }
    
    Campaign [] public campaigns;
    string [] public status_of_campaigns;
    
    
    function createcampaign
    (
        string description1,
        string typeofcampaign1,
        string targetcity1,
        uint minimumcontribution1,
        address managerid1
    )
    public
    {
        uint [] memory initialize_array;
        address [] memory _backerslist;
        
        Campaign memory newcampaign = Campaign ({
           campaignid: campaigncount,
           description: description1,
           typeofcampaign: typeofcampaign1,
           targetcity: targetcity1,
           minimumcontribution: minimumcontribution1,
           managerid: managerid1,
           priority: 0,
           approvedby: 0x0000000000000000,
           proposalhash: "0x0000000000000000",
           backerscount: 0,
           requestlist: initialize_array,
           backerslist: _backerslist,
           totalmoney: 0
        }) ;
        
        campaigns.push(newcampaign);
        status_of_campaigns.push("Pending");
        campaigncount++;
        
        
    }
    
    function change_status_of_campaign
    (
        uint campaignid, 
        string new_status,
        uint _priority,
        address approver
    ) 
    public
    {
        status_of_campaigns[campaignid]=new_status;
        campaigns[campaignid].priority = _priority;
         campaigns[campaignid].approvedby = approver;
        
    }
    
    struct Request
    {
        uint requestid;
        uint campaignid;
        string description;
        uint value;
        address recipient;
        bool status;
        uint approvalCount;
        mapping(address => bool) approvals;
        uint yescount;
    }
    
    uint public requestcount=0;
    Request[] public requests;
    
    function contribute(uint campaignid) public payable 
    {
        
        require(msg.value >= campaigns[campaignid].minimumcontribution);

        campaigns[campaignid].backers[msg.sender] = true;
        campaigns[campaignid].backerscount++;
        campaigns[campaignid].totalmoney +=(msg.value);
    }
    
    function create_spend_Request
    (
        string description, 
        uint value,
        address recipient,
        uint campaignid1
    )
    public 
    {
        Request memory newRequest = Request
        ({
           requestid: requestcount,
           description: description,
           value: value,
           recipient: recipient,
           status: false,
           approvalCount: 0,
           yescount: 0,
           campaignid: campaignid1
        });
        
        requests.push(newRequest);
        campaigns[campaignid1].requestlist.push(requestcount);
        requestcount++;
    }
    
     function approve_spend_Request(uint request_index) public 
     {
        Request storage request = requests[request_index];
        uint campaignid = request.campaignid;
        require(campaigns[campaignid].backers[msg.sender]);
        require(!request.approvals[msg.sender]);

        request.approvals[msg.sender] = true;
        request.approvalCount++;
        request.yescount++;
    }
     function reject_spend_Request(uint request_index) public 
     {
        Request storage request = requests[request_index];
        uint campaignid = request.campaignid;
        require(campaigns[campaignid].backers[msg.sender]);
        require(!request.approvals[msg.sender]);

        request.approvals[msg.sender] = true;
        request.approvalCount++;
    }
    
    function finalize_spend_Request(uint request_index) public 
    {
        Request storage request = requests[request_index];
        uint campaignid = request.campaignid;
        require(request.yescount > ((campaigns[campaignid].backerscount)/2));
        require(!request.status);

        request.recipient.transfer(request.value);
        campaigns[campaignid].totalmoney -=(request.value);
        request.status = true;
    }
}