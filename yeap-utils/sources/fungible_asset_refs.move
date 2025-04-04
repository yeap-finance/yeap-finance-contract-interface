// SPDX-License-Identifier: BUSL-1.1
module yeap_utils::fungible_asset_refs {
    use aptos_framework::fungible_asset;
    use aptos_framework::fungible_asset::{BurnRef, MintRef, MutateMetadataRef, TransferRef};
    use aptos_framework::object::ConstructorRef;

    struct AssetRefs has key, store {
        mint_asset_ref: MintRef,
        burn_asset_ref: BurnRef,
        transfer_asset_ref: TransferRef,
        mutate_metadata_ref: MutateMetadataRef
    }

    public fun new(asset_object_ref: &ConstructorRef): AssetRefs {
        AssetRefs {
            mint_asset_ref: fungible_asset::generate_mint_ref(asset_object_ref),
            burn_asset_ref: fungible_asset::generate_burn_ref(asset_object_ref),
            transfer_asset_ref: fungible_asset::generate_transfer_ref(asset_object_ref),
            mutate_metadata_ref: fungible_asset::generate_mutate_metadata_ref(asset_object_ref)
        }
    }

    // This function is used to drop the object.
    // once the object is dropped, the object reference will be invalid.
    // this function is used to prevent the object from being deleted.
    // this function is used to prevent the object from being transferred.
    // this function is used to prevent the object from being derived.
    // this function is used to prevent the object from being extended.

    public fun drop(self: AssetRefs)  {
        let AssetRefs {..} = self;
    }

    public fun mint_asset_ref(self: &AssetRefs): &MintRef {
        &self.mint_asset_ref
    }

    public fun burn_asset_ref(self: &AssetRefs): &BurnRef {
        &self.burn_asset_ref
    }

    public fun transfer_asset_ref(self: &AssetRefs): &TransferRef {
        &self.transfer_asset_ref
    }

    public fun mutate_metadata_ref(self: &AssetRefs): &MutateMetadataRef {
        &self.mutate_metadata_ref
    }


}
