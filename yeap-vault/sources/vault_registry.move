// SPDX-License-Identifier: BUSL-1.1
module yeap_vault::vault_registry {
    use std::signer::address_of;
    use aptos_std::smart_vector;

    friend yeap_vault::vault;
    struct VaultRegistry has key {
        vaults: smart_vector::SmartVector<address>
    }

    fun init_module(deployer: &signer) {
        assert!(address_of(deployer) == @yeap_vault);
        move_to(deployer, VaultRegistry {
            vaults: smart_vector::new()
        });
    }

    public(friend) fun register_vault(vault: address) acquires VaultRegistry {
        let registry = borrow_global_mut<VaultRegistry>(@yeap_vault);
        registry.vaults.push_back(vault);
    }

    #[view]
    public fun all_vaults(): vector<address> acquires VaultRegistry {
        let registry = borrow_global<VaultRegistry>(@yeap_vault);
        registry.vaults.to_vector()
    }
}
