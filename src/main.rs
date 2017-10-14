extern crate noether;
use std::env;
use noether::BalanceChecker;

fn main() {
    let args: Vec<String> = env::args().collect();
    let balance_checker = BalanceChecker::new(&args[1]);
    balance_checker.is_balanced();
}
