// SPDX-License-Identifier: BUSL-1.1
module yeap_utils::object_refs {

    use std::option;
    use std::option::Option;
    use aptos_framework::object;
    use aptos_framework::object::{ConstructorRef, ObjectCore};

    struct ObjRefs has store, key {
        extended_object_ref: object::ExtendRef,
        derived_object_ref: object::DeriveRef,
        delete_object_ref: Option<object::DeleteRef>,
        transfer_object_ref: Option<object::TransferRef>
    }

    public fun new(object_ref: &ConstructorRef): ObjRefs {
        let extended_object_ref = object::generate_extend_ref(object_ref);
        let derived_object_ref = object::generate_derive_ref(object_ref);
        let delete_object_ref =
            if (object::can_generate_delete_ref(object_ref)) {
                option::some(object::generate_delete_ref(object_ref))
            } else {
                option::none()
            };
        let transfer_object_ref =
            if (object::is_untransferable(object::object_from_constructor_ref<ObjectCore>(object_ref))) {
                option::none()
            } else {
                option::some(object::generate_transfer_ref(object_ref))
            };
        ObjRefs { extended_object_ref, derived_object_ref, delete_object_ref, transfer_object_ref }
    }

    public fun object_address(self: &ObjRefs): address {
        object::address_from_extend_ref(&self.extended_object_ref)
    }

    public fun can_delete(self: &ObjRefs): bool {
        self.delete_object_ref.is_some()
    }

    /// Return delete_object_ref of the object.
    /// error if the object is not deletable.
    public fun delete_ref(self: &ObjRefs): &object::DeleteRef {
        self.delete_object_ref.borrow()
    }

    public fun transfer_ref(self: &ObjRefs): &object::TransferRef {
        self.transfer_object_ref.borrow()
    }

    public fun derived_ref(self: &ObjRefs): &object::DeriveRef {
        &self.derived_object_ref
    }

    public fun extended_ref(self: &ObjRefs): &object::ExtendRef {
        &self.extended_object_ref
    }

    /// This function is used to delete the object.
    /// once the object is deleted, the object reference will be invalid.
    /// So self is destoryed after this function is called.
    public fun delete_object(self: ObjRefs) {
        let ObjRefs { delete_object_ref: debt_store_delete_object_ref,.. } = self;
        object::delete(debt_store_delete_object_ref.destroy_some());
    }

    /// delete the object references.
    public fun drop(self: ObjRefs) {
        let ObjRefs { .. } = self;
    }
}
