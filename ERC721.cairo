# SPDX-License-Identifier: MIT
# OpenZeppelin Contracts for Cairo v0.2.1 (token/erc721/ERC721_Mintable_Burnable.cairo)

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import (
    Uint256,
    uint256_add,
    uint256_sub,
    uint256_le,
    uint256_lt,
    uint256_check,
    uint256_eq,
)


from openzeppelin.access.ownable import Ownable
from openzeppelin.introspection.ERC165 import ERC165
from openzeppelin.token.erc721.library import ERC721

from starkware.starknet.common.syscalls import get_contract_address, get_caller_address


#
# Declaring storage variables 
#

@storage_var
func sex_characteristics(tokenId: Uint256) -> (sex : felt):
end


@storage_var
func legs_characteristics(tokenId: Uint256) -> (sex : felt):
end


@storage_var
func wings_characteristics(tokenId: Uint256) -> (sex : felt):
end

@storage_var
func n_minted() -> (n: Uint256):
end

@storage_var
func dead_balances(owner: felt) -> (n: Uint256):
end

@storage_var
func is_dead(tokenId: Uint256) -> (n: felt):
end

@storage_var
func ownerIndexLMAO(account: felt, token_id: Uint256) -> (token_id: Uint256):
end

@storage_var
func ownerIndex(account: felt, token_id: Uint256) -> (token_id: Uint256):
end


#
# Constructor
#

@constructor
func constructor{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(
        name: felt,
        symbol: felt,
        owner: felt
    ):
    n_minted.write(Uint256(0, 0))
    ERC721.initializer(name, symbol)
    Ownable.initializer(owner)
    return ()
end

#
# Getters
#

@view
func supportsInterface{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(interfaceId: felt) -> (success: felt):
    let (success) = ERC165.supports_interface(interfaceId)
    return (success)
end

@view
func name{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }() -> (name: felt):
    let (name) = ERC721.name()
    return (name)
end

@view
func symbol{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }() -> (symbol: felt):
    let (symbol) = ERC721.symbol()
    return (symbol)
end

@view
func balanceOf{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(owner: felt) -> (_balance: Uint256):
    let (balance) = ERC721.balance_of(owner)
    let (d_balance) = dead_balances.read(owner)
     
    let (res) = uint256_sub(balance, d_balance)

    return (res)
end

@view
func ownerOf{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(tokenId: Uint256) -> (owner: felt):
    let (owner: felt) = ERC721.owner_of(tokenId)
    return (owner)
end

@view
func getApproved{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(tokenId: Uint256) -> (approved: felt):
    let (approved: felt) = ERC721.get_approved(tokenId)
    return (approved)
end

@view
func isApprovedForAll{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(owner: felt, operator: felt) -> (isApproved: felt):
    let (isApproved: felt) = ERC721.is_approved_for_all(owner, operator)
    return (isApproved)
end

@view
func tokenURI{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(tokenId: Uint256) -> (tokenURI: felt):
    let (tokenURI: felt) = ERC721.token_uri(tokenId)
    return (tokenURI)
end

@view
func owner{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }() -> (owner: felt):
    let (owner: felt) = Ownable.owner()
    return (owner)
end

@view 
func get_animal_characteristics{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(token_id : Uint256) -> (sex: felt, legs: felt, wings: felt):
    let (sex_read) = sex_characteristics.read(token_id)
    let (wings_read) = wings_characteristics.read(token_id)
    let (legs_read) = legs_characteristics.read(token_id)

    return (sex = sex_read, legs = legs_read ,wings = wings_read)
end

@view
func get_n_minted{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }() -> (_n: Uint256):
    let (n: Uint256) = n_minted.read()

    return (_n = n)
end

@view
func token_of_owner_by_indexLMAO{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(account: felt, index : Uint256) -> (token_id: Uint256):
    let (tokenId) = ownerIndex.read(account, index)
    return (token_id = tokenId)
end

@view
func token_of_owner_by_index(account: felt, index: felt) -> (tokenId: Uint256):
    let res = Uint256(1,0)
    return (tokenId = res)
end

#
# Externals
#

@external
func approve{
        pedersen_ptr: HashBuiltin*,
        syscall_ptr: felt*,
        range_check_ptr
    }(to: felt, tokenId: Uint256):
    ERC721.approve(to, tokenId)
    return ()
end

@external
func setApprovalForAll{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(operator: felt, approved: felt):
    ERC721.set_approval_for_all(operator, approved)
    return ()
end

@external
func transferFrom{
        pedersen_ptr: HashBuiltin*,
        syscall_ptr: felt*,
        range_check_ptr
    }(
        from_: felt,
        to: felt,
        tokenId: Uint256
    ):
    ERC721.transfer_from(from_, to, tokenId)
    return ()
end

@external
func safeTransferFrom{
        pedersen_ptr: HashBuiltin*,
        syscall_ptr: felt*,
        range_check_ptr
    }(
        from_: felt,
        to: felt,
        tokenId: Uint256,
        data_len: felt,
        data: felt*
    ):
    ERC721.safe_transfer_from(from_, to, tokenId, data_len, data)
    return ()
end

@external
func mint{
        pedersen_ptr: HashBuiltin*,
        syscall_ptr: felt*,
        range_check_ptr
    }(to: felt, tokenId: Uint256):
    let (n) = n_minted.read()
    let one_as_uint256 : Uint256 = Uint256(1, 0)
    let (n_new, _) = uint256_add(n, one_as_uint256)
    n_minted.write(n_new)

    Ownable.assert_only_owner()
    ERC721._mint(to, tokenId)
    return ()
end

@external
func burn{
        pedersen_ptr: HashBuiltin*,
        syscall_ptr: felt*,
        range_check_ptr
    }(tokenId: Uint256):
    ERC721.assert_only_token_owner(tokenId)
    ERC721._burn(tokenId)
    return ()
end

@external
func setTokenURI{
        pedersen_ptr: HashBuiltin*,
        syscall_ptr: felt*,
        range_check_ptr
    }(tokenId: Uint256, tokenURI: felt):
    Ownable.assert_only_owner()
    ERC721._set_token_uri(tokenId, tokenURI)
    return ()
end

@external
func transferOwnership{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(newOwner: felt):
    Ownable.transfer_ownership(newOwner)
    return ()
end

@external
func renounceOwnership{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }():
    Ownable.renounce_ownership()
    return ()
end

@external
func declare_animal{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(sex : felt, legs : felt, wings : felt) -> (token_id : Uint256):
    let (sender_address) = get_caller_address()

    let (n) = n_minted.read()
    let one_as_uint256 : Uint256 = Uint256(1, 0)
    let (n_new, _) = uint256_add(n, one_as_uint256)
    n_minted.write(n_new)

    ERC721._mint(to=sender_address, token_id=n_new)
    
    sex_characteristics.write(n_new, sex)
    wings_characteristics.write(n_new, wings)
    legs_characteristics.write(n_new, legs)

    return (token_id = n_new)
end

@external
func declare_dead_animal{
        pedersen_ptr: HashBuiltin*,
        syscall_ptr: felt*,
        range_check_ptr
    }(token_id : Uint256):
    let (sender_address) = get_caller_address()

    let (owner_addr) = ERC721.owner_of(token_id)

    sex_characteristics.write(token_id, 0)
    wings_characteristics.write(token_id, 0)
    legs_characteristics.write(token_id, 0)

    let (d_balance) = dead_balances.read(owner_addr)
    let (new_d_bal, _) = uint256_add(d_balance, Uint256(1,0))
    dead_balances.write(owner_addr, new_d_bal)

    return ()
end