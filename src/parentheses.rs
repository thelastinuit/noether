/// Parentheses::BalanceChecker
/// Verify if a string of parentheses is balanced.
///
/// Usage:
/// ```
/// let balance_checker = BalanceChecker::new(&string]);
/// balance_checker.is_balanced();
/// ```

pub struct BalanceChecker<'a> {
    stream: &'a String,
}

impl<'a> BalanceChecker<'a> {
    pub fn new(stream: &String) -> BalanceChecker {
        BalanceChecker {
            stream: stream
        }
    }

    pub fn is_balanced(&self) {
        let mut count = 0;

        for i in self.stream.chars() {
            match i {
                '(' => count = count + 1,
                ')' => count = count - 1,
                _ => panic!("Illegal char")
            }

            if count < 0 {
                println!("Imbalance at index {}", i);
            }
        }

        if count != 0 {
            println!("Imbalance at index {}", self.stream.len() - 1);
        } else {
            println!("All good!");
        }
    }
}
