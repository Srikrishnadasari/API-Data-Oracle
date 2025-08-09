module sri_address::ApiDataOracle {
    use aptos_framework::signer;
    use aptos_framework::timestamp;
    use std::string::String;

    
    struct DataEntry has store, key {
        data_value: String,     
        last_updated: u64,      
        source_url: String,      
        is_active: bool,         
    }

   
    const E_DATA_ENTRY_NOT_FOUND: u64 = 1;
    const E_UNAUTHORIZED_UPDATE: u64 = 2;

    
    public fun register_data_source(
        oracle_owner: &signer, 
        source_url: String, 
        initial_data: String
    ) {
        let data_entry = DataEntry {
            data_value: initial_data,
            last_updated: timestamp::now_seconds(),
            source_url,
            is_active: true,
        };
        move_to(oracle_owner, data_entry);
    }

   
    public fun update_data(
        oracle_owner: &signer, 
        owner_address: address, 
        new_data: String
    ) acquires DataEntry {
         
        assert!(signer::address_of(oracle_owner) == owner_address, E_UNAUTHORIZED_UPDATE);
        
       
        assert!(exists<DataEntry>(owner_address), E_DATA_ENTRY_NOT_FOUND);
        
        let data_entry = borrow_global_mut<DataEntry>(owner_address);
        
        
        data_entry.data_value = new_data;
        data_entry.last_updated = timestamp::now_seconds();
    }


    public fun get_data(owner_address: address): (String, u64, String, bool) acquires DataEntry {
        assert!(exists<DataEntry>(owner_address), E_DATA_ENTRY_NOT_FOUND);
        
        let data_entry = borrow_global<DataEntry>(owner_address);
        (
            data_entry.data_value,
            data_entry.last_updated,
            data_entry.source_url,
            data_entry.is_active
        )
    }

}
