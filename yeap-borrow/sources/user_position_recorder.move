// SPDX-License-Identifier: BUSL-1.1
module yeap_borrow::user_position_recorder {
    use std::signer::address_of;
    use aptos_std::smart_table;

    friend yeap_borrow::position_manager;

    struct UserPositions has key {
        positions: smart_table::SmartTable<address, address>
    }

    public(friend) fun record_open_position(
        user: &signer,
        position: address
    ) acquires UserPositions {
        if (exists<UserPositions>(address_of(user))) {
            let user_positions = borrow_global_mut<UserPositions>(address_of(user));
            user_positions.positions.add(position, position);
        } else {
            let user_positions = UserPositions {
                positions: smart_table::new()
            };
            user_positions.positions.add(position, position);
            move_to<UserPositions>(user, user_positions);
        }
    }

    public(friend) fun record_close_position(
        user: address,
        position: address
    ) acquires UserPositions {
        let user_positions = borrow_global_mut<UserPositions>(user);

        user_positions.positions.remove(position);
    }

    #[view]
    public fun get_user_positions(user: address): vector<address> acquires UserPositions {
        let user_positions = borrow_global<UserPositions>(user);
        user_positions.positions.keys()
    }
}
