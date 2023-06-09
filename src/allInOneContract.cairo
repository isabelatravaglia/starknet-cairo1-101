use starknet::ContractAddress;
use array::ArrayTrait;
// use option::OptionTrait;

#[abi]
trait IVariousExercises {
    fn claim_points();
}

#[abi]
trait IEx2 {
    fn my_secret_value() -> u128;
    fn claim_points(secret_value: u128);
}

#[abi] 
trait IEx3 {
    fn increment_counter();
    fn decrement_counter();
    fn claim_points();
}

#[abi]
trait IEx4 {
    fn assign_user_slot();
    fn get_user_slots(account: ContractAddress) -> u128;
    fn get_values_mapped(slot: u128) -> u128;
    fn claim_points(expected_value: u128);
}

#[abi]
trait IEx5 {
    fn assign_user_slot();
    fn copy_secret_value_to_readable_mapping();
    fn get_user_slots(account: ContractAddress) -> u128;
    fn get_user_values(account: ContractAddress) -> u128;
    fn claim_points(expected_value: u128);
}

#[abi]
trait IEx6 {
    fn assign_user_slot();
    fn external_handler_for_internal_function(a_value: u128);
    fn get_user_slots(account: ContractAddress) -> u128;
    fn get_user_values(account: ContractAddress) -> u128;
    fn claim_points(expected_value: u128);
}

#[abi]
trait IEx7 {
    fn claim_points(value_a: u128, value_b: u128);
}

#[abi]
trait IEx8 {
    fn set_user_values(account: ContractAddress, values: Array::<u128>);
    fn claim_points();
}

#[abi]
trait IEx9 {
    fn claim_points(array: Array::<u128>);
}

#[abi]
trait IEx10 {
    fn claim_points(secret_value_i_guess: u128, next_secret_value_i_chose: u128);
    fn get_ex10b_address() -> ContractAddress;
}

#[abi]
trait IEx10b {
    fn get_secret_value() -> u128;
    fn change_secret_value(new_secret_value: u128);
}

#[abi]
trait IEx11 {
    fn claim_points(secret_value_i_guess: u128, next_secret_value_i_chose: u128);
    fn secret_value() -> u128;
}



#[contract]
mod AllInOneContract {

    use starknet::get_caller_address;
    use starknet::get_contract_address;
    use starknet::ContractAddress;
    use array::ArrayTrait;
    use option::OptionTrait;

    use super::IVariousExercisesDispatcher;
    use super::IVariousExercisesDispatcherTrait;
    use super::IEx2Dispatcher;
    use super::IEx2DispatcherTrait;
    use super::IEx3Dispatcher;
    use super::IEx3DispatcherTrait;
    use super::IEx4Dispatcher;
    use super::IEx4DispatcherTrait;
    use super::IEx5Dispatcher;
    use super::IEx5DispatcherTrait;
    use super::IEx6Dispatcher;
    use super::IEx6DispatcherTrait;
    use super::IEx7Dispatcher;
    use super::IEx7DispatcherTrait;
    use super::IEx8Dispatcher;
    use super::IEx8DispatcherTrait;
    use super::IEx9Dispatcher;
    use super::IEx9DispatcherTrait;
    use super::IEx10Dispatcher;
    use super::IEx10DispatcherTrait;
    use super::IEx10bDispatcher;
    use super::IEx10bDispatcherTrait;
    // use super::IEx11Dispatcher;
    // use super::IEx11DispatcherTrait;
    // use super::IEx12Dispatcher;
    // use super::IEx12DispatcherTrait;
    // use super::IEx13Dispatcher;
    // use super::IEx13DispatcherTrait;


    ////////////////////////////////
    // Internal Constructor
    ////////////////////////////////
    fn ex_initializer(
       _contract_owner: ContractAddress,
        _ex1: ContractAddress,
        _ex2: ContractAddress,
        _ex3: ContractAddress,
        _ex4: ContractAddress,
        _ex5: ContractAddress,
        _ex6: ContractAddress,
        _ex7: ContractAddress,
        _ex8: ContractAddress,
        _ex9: ContractAddress,
        _ex10: ContractAddress,
        _ex11: ContractAddress,
        _ex12: ContractAddress,
        _ex13: ContractAddress,
        _ex14: ContractAddress,
    ) {
        contract_owner_storage::write(_contract_owner);
        exercise_addresses_storage::write(1_u128, _ex1);
        exercise_addresses_storage::write(2_u128, _ex2);
        exercise_addresses_storage::write(3_u128, _ex3);
        exercise_addresses_storage::write(4_u128, _ex4);
        exercise_addresses_storage::write(5_u128, _ex5);
        exercise_addresses_storage::write(6_u128, _ex6);
        exercise_addresses_storage::write(7_u128, _ex7);
        exercise_addresses_storage::write(8_u128, _ex8);
        exercise_addresses_storage::write(9_u128, _ex9);
        exercise_addresses_storage::write(10_u128, _ex10);
        exercise_addresses_storage::write(11_u128, _ex11);
        exercise_addresses_storage::write(12_u128, _ex12);
        exercise_addresses_storage::write(13_u128, _ex13);
        exercise_addresses_storage::write(14_u128, _ex14);
        
    }


    struct Storage {
        exercise_addresses_storage: LegacyMap::<u128, ContractAddress>,
        contract_owner_storage: ContractAddress
    }


    #[constructor]
    fn constructor(
        _contract_owner: ContractAddress,
        _ex1: ContractAddress,
        _ex2: ContractAddress,
        _ex3: ContractAddress,
        _ex4: ContractAddress,
        _ex5: ContractAddress,
        _ex6: ContractAddress,
        _ex7: ContractAddress,
        _ex8: ContractAddress,
        _ex9: ContractAddress,
        _ex10: ContractAddress,
        _ex11: ContractAddress,
        _ex12: ContractAddress,
        _ex13: ContractAddress,
        _ex14: ContractAddress
    ) {
        ex_initializer(_contract_owner, _ex1, _ex2, _ex3, _ex4, _ex5, _ex6, _ex7, _ex8, _ex9, _ex10, _ex11, _ex12, _ex13, _ex14);
    }

    // Validate all exercises Function
    // validate_various_exercises: should collect points from the previous exercises by calling their claim_points function.
    // Then call ex14 claim_points function so that it can check that all the previous points were collected.


    #[view]
    fn contract_owner() -> ContractAddress {
        contract_owner_storage::read()
    }

    #[external]
    fn validate_various_exercises() {

        let this_contract = get_contract_address();

        // Ex1
        let ex1_addr = exercise_addresses_storage::read(1_u128);
        IVariousExercisesDispatcher{contract_address: ex1_addr}.claim_points();

        // Ex2
        let ex2_addr = exercise_addresses_storage::read(2_u128);
        let secret_value = IEx2Dispatcher{contract_address: ex2_addr}.my_secret_value();
        IEx2Dispatcher{contract_address: ex2_addr}.claim_points(secret_value);

        // Ex3
        let ex3_addr = exercise_addresses_storage::read(3_u128);
        IEx3Dispatcher{contract_address: ex3_addr}.increment_counter();
        IEx3Dispatcher{contract_address: ex3_addr}.increment_counter();
        IEx3Dispatcher{contract_address: ex3_addr}.decrement_counter();
        IEx3Dispatcher{contract_address: ex3_addr}.claim_points();

        // Ex4
        let caller: ContractAddress = get_caller_address();
        let ex4_addr = exercise_addresses_storage::read(4_u128);
        IEx4Dispatcher{contract_address: ex4_addr}.assign_user_slot();
        let user_slot = IEx4Dispatcher{contract_address: ex4_addr}.get_user_slots(caller);
        let mis_mapped_value = IEx4Dispatcher{contract_address: ex4_addr}.get_values_mapped(user_slot);
        let expected_mapped_value = mis_mapped_value - 32_u128;
        IEx4Dispatcher{contract_address: ex4_addr}.claim_points(expected_mapped_value);

        // Ex5
        let caller: ContractAddress = get_caller_address();
        let ex5_addr = exercise_addresses_storage::read(5_u128);
        IEx5Dispatcher{contract_address: ex5_addr}.assign_user_slot();
        IEx5Dispatcher{contract_address: ex5_addr}.copy_secret_value_to_readable_mapping();
        let correct_secret_value = IEx5Dispatcher{contract_address: ex5_addr}.get_user_values(caller) + 23_u128;
        let expected_value = correct_secret_value - 32_u128;
        IEx5Dispatcher{contract_address: ex5_addr}.claim_points(expected_value);
        
        // Ex6
        let caller: ContractAddress = get_caller_address();
        let ex6_addr = exercise_addresses_storage::read(6_u128);
        IEx6Dispatcher{contract_address: ex6_addr}.assign_user_slot();
        let useless_random_value = 49_u128;
        IEx6Dispatcher{contract_address: ex6_addr}.external_handler_for_internal_function(useless_random_value);
        let expected_value = IEx6Dispatcher{contract_address: ex6_addr}.get_user_values(caller);
        IEx6Dispatcher{contract_address: ex6_addr}.claim_points(expected_value);

        // Ex 7
        let ex7_addr = exercise_addresses_storage::read(7_u128);
        IEx7Dispatcher{contract_address: ex7_addr}.claim_points(42_u128, 0_u128);

        // Ex 8
        let caller: ContractAddress = get_caller_address();
        let ex8_addr = exercise_addresses_storage::read(8_u128);
        let mut values = ArrayTrait::new();
        values.append(0_u128);
        values.append(1_u128);
        values.append(2_u128);
        values.append(3_u128);
        values.append(4_u128);
        values.append(5_u128);
        values.append(6_u128);
        values.append(7_u128);
        values.append(8_u128);
        values.append(9_u128);
        values.append(10_u128);
        IEx8Dispatcher{contract_address: ex8_addr}.set_user_values(caller, values);
        IEx8Dispatcher{contract_address: ex8_addr}.claim_points();

        // Ex 9
        let ex9_addr = exercise_addresses_storage::read(9_u128);
        let mut values = ArrayTrait::new();
        values.append(10_u128);
        values.append(15_u128);
        values.append(20_u128);
        values.append(25_u128);
        values.append(30_u128);
        IEx9Dispatcher{contract_address: ex9_addr}.claim_points(values);

        //  Ex 10
        let ex10_addr = exercise_addresses_storage::read(10_u128);
        let ex10b_addr = IEx10Dispatcher{contract_address: ex10_addr}.get_ex10b_address();
        let secret_value = IEx10bDispatcher{contract_address: ex10b_addr}.get_secret_value();
        let next_secret_value_i_chose = secret_value + 1_u128;
        IEx10Dispatcher{contract_address: ex10_addr}.claim_points(secret_value, next_secret_value_i_chose);
        


    }

    #[external]
    fn call_ex14_claim_points() {
        // Reading caller address
        // let sender_address: ContractAddress = get_caller_address();
        let ex14_addr = exercise_addresses_storage::read(14_u128);
        IVariousExercisesDispatcher{contract_address: ex14_addr}.claim_points();
    }
}