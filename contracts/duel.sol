/**
 *Submitted for verification at FtmScan.com on 2021-09-12
*/

// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}


/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _setOwner(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _setOwner(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _setOwner(newOwner);
    }

    function _setOwner(address newOwner) private {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}


/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) private pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}


interface rarity {
    function level(uint) external view returns (uint);
    function class(uint) external view returns (uint);
    function getApproved(uint) external view returns (address);
    function ownerOf(uint) external view returns (address);
}

interface attributes {
    function character_created(uint) external view returns (bool);
    function ability_scores(uint) external view returns (uint32,uint32,uint32,uint32,uint32,uint32);
}

interface rarity_gold {
    function balanceOf(uint) external view returns (uint);
    function transferFrom(uint executor, uint from, uint to, uint amount) external returns (bool);
    function transfer(uint from, uint to, uint amount) external returns (bool);
}

interface codex_base_random {
    function dn(uint _summoner, uint _number) external view returns (uint) ;
}

contract rarity_battle is Ownable {
    string public constant name = "Rarity Battle";
    string public constant symbol = "RB";
    uint8 public constant decimals = 18;

    uint public totalSupply = 0;
    
    rarity constant rm = rarity(0xce761D788DF608BD21bdd59d6f4B54b2e27F25Bb);
    attributes constant _attr = attributes(0xB5F5AF1087A8DA62A23b08C00C6ec9af21F397a1);
    rarity_gold constant gold = rarity_gold(0x2069B76Afe6b734Fb65D1d099E7ec64ee9CC76B2);

    codex_base_random constant _random = codex_base_random(0x7426dBE5207C2b5DaC57d8e55F0959fcD99661D4);

    struct FightAnalyze {
        uint times;
        uint win;
        uint loose;
        uint combo_win;
        uint combo_loose;
    }

    uint public ticketPrice = 100e18;
    uint public freeTimes = 10;
    mapping(uint => FightAnalyze) public fightTimes;
    uint private sold;
    uint public ethRatio = 500;
    uint public SUMMONER_ID = 1788610;  // Use for exchange gold to RB

    uint public bet = 1e18;

    mapping(uint => mapping (uint => uint)) public allowance;
    mapping(uint => uint) public balanceOf;
    uint public constant maxHeros = 1000;
    uint[] public heroPool;
    mapping (uint => uint) private heroIndex;

    uint public bonusPool;
    mapping (address => uint) public bonusBalance;
    
    event Transfer(uint indexed from, uint indexed to, uint amount);
    event Approval(uint indexed from, uint indexed to, uint amount);
    event Battle(uint indexed from, uint indexed to, uint level, bool result);
    event BuyRB(uint indexed from, uint amount, bool useGold);
    event SetEthRatio(uint ratio);
    event SetTicketPrice(uint ticketPrice);
    event SetBet(uint bet);

    modifier isApprovedOrOwner(uint _summoner) {
        require(rm.getApproved(_summoner) == _msgSender() || rm.ownerOf(_summoner) == _msgSender(), "Not own or approved");
        _;
    }
    
    function health_by_class(uint _class) internal pure returns (uint health) {
        if (_class == 1) {
            health = 12;
        } else if (_class == 2) {
            health = 6;
        } else if (_class == 3) {
            health = 8;
        } else if (_class == 4) {
            health = 8;
        } else if (_class == 5) {
            health = 10;
        } else if (_class == 6) {
            health = 8;
        } else if (_class == 7) {
            health = 10;
        } else if (_class == 8) {
            health = 8;
        } else if (_class == 9) {
            health = 6;
        } else if (_class == 10) {
            health = 4;
        } else if (_class == 11) {
            health = 4;
        }
    }
    
    function health_by_class_and_level(uint _class, uint _level, uint32 _const) internal pure returns (uint health) {
        int _mod = modifier_for_attribute(_const);
        int _base_health = int(health_by_class(_class)) + _mod;
        if (_base_health <= 0) {
            _base_health = 1;
        }
        health = uint(_base_health) * _level;
    }
    
    function base_attack_bonus_by_class(uint _class) internal pure returns (uint attack) {
        if (_class == 1) {
            attack = 4;
        } else if (_class == 2) {
            attack = 3;
        } else if (_class == 3) {
            attack = 3;
        } else if (_class == 4) {
            attack = 3;
        } else if (_class == 5) {
            attack = 4;
        } else if (_class == 6) {
            attack = 3;
        } else if (_class == 7) {
            attack = 4;
        } else if (_class == 8) {
            attack = 4;
        } else if (_class == 9) {
            attack = 3;
        } else if (_class == 10) {
            attack = 2;
        } else if (_class == 11) {
            attack = 2;
        }
    }
    
    function base_attack_bonus_by_class_and_level(uint _class, uint _level) internal pure returns (uint) {
        return _level * base_attack_bonus_by_class(_class) / 4;
    }
    
    function modifier_for_attribute(uint _attribute) internal pure returns (int _modifier) {
        if (_attribute == 9) {
            return -1;
        }
        return (int(_attribute) - 10) / 2;
    }
    
    function attack_bonus(uint _class, uint _str, uint _level) internal pure returns (int) {
        return  int(base_attack_bonus_by_class_and_level(_class, _level)) + modifier_for_attribute(_str);
    }
    
    function damage(uint _str) internal pure returns (uint) {
        int _mod = modifier_for_attribute(_str);
        if (_mod <= 1) {
            return 1;
        } else {
            return uint(_mod);
        }
    }

    function _calc(uint _summoner, uint _level) internal view returns (int _health, int _damage, uint32 _dex, uint32 _int) {
        require(_attr.character_created(_summoner), "Character not created");
        uint _class = rm.class(_summoner);
        (uint32 _str, uint32 _d, uint32 _const, uint32 _i,,) = _attr.ability_scores(_summoner);
        _dex = _d;
        _int = _i;
        _health = int(health_by_class_and_level(_class, _level, _const));
        _damage = int(damage(_str)) + attack_bonus(_class, _str, _level);
    }

    function _hit(uint32 _val, uint _turns) internal view returns (bool) {
        return uint32(_random.dn(uint(_val) * 100 + _turns, 100)) < _val;
    }
    
    // fight between two heros. opponent's level set to the summoner's.
    function pvp(uint _summoner, uint _opponent) public view returns (bool) {
        uint _level = rm.level(_summoner);
        uint _turns;

        (int _health, int _damage, uint32 _dex, uint32 _int) = _calc(_summoner, _level);
        (int _opponent_health, int _opponent_damage, uint32 _opponent_dex, uint32 _opponent_int) = _calc(_opponent, _level);

        for (_turns = 0; _turns < 50; _turns++) {
            if (!_hit(_opponent_dex, _turns)) {
                _opponent_health -= _damage;
                if (_hit(_int, _turns)) {
                    _opponent_health -= _damage;
                }
                if (_opponent_health <= 0) break;
            }
            if (!_hit(_dex, _turns)) {
                _health -= _opponent_damage;
                if (_hit(_opponent_int, _turns)) {
                    _health -= _opponent_damage;
                }
                if (_health <= 0) break;
            }
        }

        return _opponent_health < _health;
    }

    // get a random opponent
    function get_opponent(uint _summoner) internal view returns (uint) {
        if (heroPool.length == 0) {
            return 0;
        }
        return heroPool[_random.dn(_summoner, heroPool.length)];
    }

    function record(uint _summoner, uint opponent, bool result) internal returns (bool) {
        if (heroIndex[_summoner] == 0) {
            if (heroPool.length < maxHeros) {
                heroPool.push(_summoner);
                heroIndex[_summoner] = heroPool.length;
                return true;
            } else if (result) {
                heroIndex[_summoner] = heroIndex[opponent];
                heroIndex[opponent] = 0;
                heroPool[heroIndex[_summoner] - 1] = _summoner;
                return true;
            }
        }
        return false;
    }

    function settlement(uint _summoner, bool result) internal returns (bool) {
        FightAnalyze memory fa = fightTimes[_summoner];
        fa.times += 1;
        if (result) {
            fa.win += 1;
            fa.combo_win += 1;
            fa.combo_loose = 0;

            uint bonus = uint(bonusPool / 2);
            if (fa.combo_win == 20 || bonusPool <= bet) {
                bonus = bonusPool;
            }
            bonusBalance[_msgSender()] += (bet + bonus);
            bonusPool -= bonus;
        } else {
            bonusPool += bet;

            fa.loose += 1;
            fa.combo_loose += 1;
            fa.combo_win = 0;
        }
        fightTimes[_summoner] = fa;
        return true;
    }
    
    // Fight cost ticketPrice of RB, and paid value >= bet
    // When win, the paid value and half of the bonusPool will add to the sender's bonusBalance. If the summoner combo_win 20 or more times, he will get the whole bonusPool.
    // When loose, the paid value will add to the bonusPool.
    function fight(uint _summoner) external payable isApprovedOrOwner(_summoner) returns (bool) {
        require(_attr.character_created(_summoner), "Character not created");
        require(msg.value == bet, 'Value not correct');
        if (fightTimes[_summoner].times >= freeTimes) {
            require(balanceOf[_summoner] >= ticketPrice, "Not enough RB for ticket");
            _transferTokens(_summoner, 0, ticketPrice);
        }
        uint opponent = get_opponent(_summoner);
        bool result = true;
        if (opponent > 0) {
            result = pvp(_summoner, opponent);
        }

        record(_summoner, opponent, result);
        settlement(_summoner, result);

        uint _level = rm.level(_summoner);
        emit Battle(_summoner, opponent, _level, result);
        return result;
    }

    // Buy RB, 1:1000
    function buy(uint _summoner) external payable isApprovedOrOwner(_summoner) {
        uint amount = msg.value * ethRatio;
        totalSupply += amount;
        balanceOf[_summoner] += amount;
        sold += msg.value;
        emit Transfer(_summoner, _summoner, amount);
        emit BuyRB(_summoner, amount, false);
    }

    /** 
     * Exchange Rarity Gold to RM, 1:1 (need approval)
     * Approval methods:
     * 1. approve the _summoner to this contract's address in rarity contract
     * 2. approve the RM spender(1788610) for _summoner in rarity_gold contract
     */
    function exchange(uint _summoner, uint _gold) external isApprovedOrOwner(_summoner) {
        require(_summoner != SUMMONER_ID, "summoner cannot be SUMMONER_ID");
        require(gold.balanceOf(_summoner) >= _gold, "Gold not enough");
        if (rm.getApproved(_summoner) == address(this)) {
            gold.transfer(_summoner, SUMMONER_ID, _gold);
        } else {
            gold.transferFrom(SUMMONER_ID, _summoner, SUMMONER_ID, _gold);
        }
        totalSupply += _gold;
        balanceOf[_summoner] += _gold;
        emit Transfer(_summoner, _summoner, _gold);
        emit BuyRB(_summoner, _gold, true);
    }

    // withdraw bonus
    function withdraw() external {
        uint256 amount = bonusBalance[_msgSender()];
        if (amount > 0) {
            bonusBalance[_msgSender()] = 0;
            Address.sendValue(payable(_msgSender()), amount);
        }
    }

    function approve(uint from, uint spender, uint amount) external isApprovedOrOwner(from) returns (bool) {
        allowance[from][spender] = amount;

        emit Approval(from, spender, amount);
        return true;
    }

    function transfer(uint from, uint to, uint amount) external isApprovedOrOwner(from) returns (bool) {
        _transferTokens(from, to, amount);
        return true;
    }

    function transferFrom(uint executor, uint from, uint to, uint amount) external isApprovedOrOwner(executor) returns (bool) {
        uint spender = executor;
        uint spenderAllowance = allowance[from][spender];

        if (spender != from && spenderAllowance != type(uint).max) {
            uint newAllowance = spenderAllowance - amount;
            allowance[from][spender] = newAllowance;

            emit Approval(from, spender, newAllowance);
        }

        _transferTokens(from, to, amount);
        return true;
    }

    function _transferTokens(uint from, uint to, uint amount) internal {
        balanceOf[from] -= amount;
        balanceOf[to] += amount;

        emit Transfer(from, to, amount);
    }

    function payOwner(address to, uint256 amount) public onlyOwner {
        require(amount <= sold, "amount too high");
        sold -= amount;
        Address.sendValue(payable(to), amount);
    }

    function setEthRatio(uint _ethRatio) public onlyOwner {
        ethRatio = _ethRatio;
        emit SetEthRatio(ethRatio);
    }

    function setTicketPrice(uint _ticketPrice) public onlyOwner {
        ticketPrice = _ticketPrice;
        emit  SetTicketPrice(ticketPrice);
    }

    function setBet(uint _bet) public onlyOwner {
        bet = _bet;
        emit  SetBet(bet);
    }
}