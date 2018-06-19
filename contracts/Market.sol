pragma solidity ^0.4.23;

contract Market {

  uint totalWedge;

  mapping (address => bool) rich;

  uint numPoor;
  mapping (address => bool) poor;
  mapping (address => uint) collected;

  modifier onlyRich(address r) {
    require(rich[r]);
    _;
  }

  modifier onlyPoor(address p) {
    require(poor[p]);
    _;
  }

  constructor(address[] richSide, address[] poorSide, uint wedge) public {
    for (uint i = 0; i < richSide.length; i ++) {
      rich[richSide[i]] = true;
    }
    for (uint i = 0; i < poorSide.length; i ++) {
      poor[poorSide[i]] = true;
    }
    numPoor = poorSide.length;
  }

  function interact(address poor) payable onlyRich(msg.sender) onlyPoor(poor) {
    require(msg.value > wedge);
    poor.transer(msg.value - wedge);
    totalWedge += wedge;
  }

  function collectWedge() onlyPoor(msg.sender) {
    leftToCollect = totalWedge / numPoor - collected[msg.sender];
    collected[msg.sender] = totalWedge / numPoor;
    msg.sender.transfer(leftToCollect);
  }
}
