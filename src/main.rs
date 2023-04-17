/* IMPORTED LIBRARIES */
use std::env;
use std::fs;
use std::fs::File;
use std::io::{Write};
// use std::str;
// use regex::Regex;

/* HELPER MODULES */
mod compiler;

fn read_file(path: &String) -> String {
    let contents = fs::read_to_string(path)
                    .expect("Something went wrong reading the file");
    contents
}

fn create_file(code: &String, path: &String) {
    let f = File::create(path);
    match f {
        Ok(mut f) => {
            f.write_all(code.as_bytes()).unwrap();
            println!("SUCCESS");
        },
        Err(e) => {
            println!("Error: {}",e);
        },
    }
}

fn get_args() -> Vec<String> {
    let args: Vec<String> = env::args().collect();
    args
}



fn main() {
    if env::args().count() != 2 {
        println!("Usage: cargo run -- <bf file absolute path>");
        return;
    }

    let args = get_args();
    let bf_path = &args[1];
    let file_string = read_file(bf_path);
    let tokens = compiler::lex(file_string);
    let out = compiler::simple_compile(tokens);
    let macros = read_file(&"lab2_macros.asm".to_string());
    let data = read_file(&"lab2_data.asm".to_string());
    let code = format!("{}{}{}",macros,out,data);
    create_file(&code,&"test.asm".to_string());
    // let ast = compiler::parse(tokens);
    // println!("{}",file_string);
    // println!("{:?}",tokens);
    // println!("{:?}",ast);
    // println!("{}",out);
}

// cargo run -- test.bf
// cargo run -- tests/add_nums.bf
// cargo run -- tests/geeks_for_geeks.bf
// cargo run -- tests/hello_world_1.bf
// cargo run -- tests/hello_world_2.bf
// cargo run -- tests/parity.bf
// java -jar Mars4_5.jar nc test.asm