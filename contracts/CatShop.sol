pragma solidity >=0.5.0 < 0.6.0;
contract CatShop {
 
 struct cat {
 string color;
 string breed;
 uint age;
 string name;
 string sex;
 string photo_url;
 uint id;
 address adopter; 
 bool adopted;
 }
 
 struct adopter {
 address id_adopter;
 uint cats_adopted;
 mapping (uint => cat) adopters_cats;
 }
 
 mapping (address => adopter) public adopters;
 mapping (uint => cat) public allCats;
 uint public n_cats;
 address public owner;
 
 modifier onlyOwner(){
 require(msg.sender == owner);
 _;
 }
 constructor() public { 
 owner = msg.sender;
 }
 
 function addCat(
 string memory _color, 
 string memory _breed,
 string memory _name,
 string memory _sex,
 string memory _url,
 uint _age 
 ) public onlyOwner returns(bool){
 cat memory newCat = cat({color: _color, 
 breed: _breed, 
 age: _age, 
 photo_url: _url,
 name: _name, 
 sex: _sex, 
 adopter: address(0), 
 id: n_cats++,
 adopted: false
 });
allCats[newCat.id] = newCat;
return true;
 
 } 
 
 function adoptCat(uint _catid)public returns(bool) {
 require(_catid <= n_cats, "Cat doesn't exist");
 require(allCats[_catid].adopted == false, "Cat already adopted");
 allCats[_catid].adopter = msg.sender;
 allCats[_catid].adopted = true;
 adopters[msg.sender].id_adopter = msg.sender;
 adopters[msg.sender].cats_adopted++;
 adopters[msg.sender].adopters_cats[adopters[msg.sender].cats_adopted] = allCats[_catid];
 return true;
 }
 
}