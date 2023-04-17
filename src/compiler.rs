// use std::collections::HashMap;
use std::process;

/*
 * THIS SECTION CONTAINS THE LEXER IMPLEMENTATION FOR BRAINFUCK
 * 
 */


#[derive(Debug, Copy, Clone, Eq, Hash, PartialEq)]
pub enum TokenTypes {
    Plus,
    Minus,
    Left,
    Right,
    Dot,
    Comma,
    OpenBracket,
    CloseBracket,
}

#[derive(Debug, Clone, PartialEq)]
pub struct Token {
    token_type: TokenTypes,
    value: String,
}

pub fn lex(file_string: String) -> Vec<Token> {
    let mut tokens: Vec<Token> = Vec::new();
    let mut chars = file_string.chars();
    let mut current_char = chars.next();

    while current_char != None {
        match current_char.unwrap() {
            '+' => tokens.push(Token {
                token_type: TokenTypes::Plus,
                value: String::from("+"),
            }),
            '-' => tokens.push(Token {
                token_type: TokenTypes::Minus,
                value: String::from("-"),
            }),
            '<' => tokens.push(Token {
                token_type: TokenTypes::Left,
                value: String::from("<"),
            }),
            '>' => tokens.push(Token {
                token_type: TokenTypes::Right,
                value: String::from(">"),
            }),
            '.' => tokens.push(Token {
                token_type: TokenTypes::Dot,
                value: String::from("."),
            }),
            ',' => tokens.push(Token {
                token_type: TokenTypes::Comma,
                value: String::from(","),
            }),
            '[' => tokens.push(Token {
                token_type: TokenTypes::OpenBracket,
                value: String::from("["),
            }),
            ']' => tokens.push(Token {
                token_type: TokenTypes::CloseBracket,
                value: String::from("]"),
            }),
            _ => (),
        }
        current_char = chars.next();
    }
    tokens
}

/*
 * THIS SECTION CONTAINS THE PARSER IMPLEMENTATION FOR BRAINFUCK
 * 
 */

 pub struct Loop {
    token: Token,
    count: i32,
}

pub fn simple_compile(mut tokens: Vec<Token>) -> String {
    let label_base = "loop".to_string();
    let point_name = "pointer".to_string();
    let mut loop_stack: Vec<Loop> = Vec::new();
    let mut label_count = 0;
    let mut out_string = format!(".text\nla $s0, {}\nla $s1, {}\n", point_name, point_name).to_string();

    for token in tokens.iter_mut() {
        // println!("{:?}",token);
        
        if matches!(token.token_type, TokenTypes::Plus) {
            out_string.push_str("bf_increment\n");
        } else if matches!(token.token_type, TokenTypes::Minus) {
            out_string.push_str("bf_decrement\n");
        } else if matches!(token.token_type, TokenTypes::Left) {
            out_string.push_str("bf_left\n");
        } else if matches!(token.token_type, TokenTypes::Right) {
            out_string.push_str("bf_right\n");
        } else if matches!(token.token_type, TokenTypes::Dot) {
            out_string.push_str("bf_print\n");
        } else if matches!(token.token_type, TokenTypes::Comma) {
            out_string.push_str("bf_read\n");
        }
        // START OF LOOP HANDLING
        else if matches!(token.token_type, TokenTypes::OpenBracket) {
            loop_stack.push(Loop {
                token: token.clone(),
                count: label_count,
            });

            let label_string = format!("{}_{}", label_base, label_count);
            let macro_string = format!("bf_loop_start({}_end)\n", label_string);
            out_string.push_str(format!("{}_start:\n", label_string).as_str());
            out_string.push_str(&macro_string);
            label_count += 1;
        }
        // END OF LOOP HANDLING
        else if matches!(token.token_type, TokenTypes::CloseBracket) {
            if loop_stack.is_empty() || !matches!(loop_stack.last().unwrap().token.token_type, TokenTypes::OpenBracket)
            {
                println!("Error: Unmatched closing bracket");
                process::exit(1);
            }
            
            let popped_loop = loop_stack.pop().unwrap();
            let label_string = format!("{}_{}", label_base, popped_loop.count);
            let macro_string = format!("bf_loop_end({}_start)\n", label_string);
            out_string.push_str(&macro_string);
            out_string.push_str(format!("{}_end:\n", label_string).as_str());
            
        }
    }

    if !loop_stack.is_empty() {
        println!("Error: Unmatched opening bracket");
        process::exit(1);
    }

    out_string
}



// #[derive(Debug, Copy, Clone, Eq, Hash, PartialEq)]
// pub enum GrammarElements {
//     Start,
//     Term,
//     Loop,
//     Action,
//     Terminal(TokenTypes),
// }

// #[derive(Debug, Clone, Eq, Hash, PartialEq)]
// pub struct Choice {
//     picked: i32,
//     max: i32,
// }

// #[derive(Debug, Clone, PartialEq)]
// pub struct Node {
//     pub grammar_type: GrammarElements,
//     pub token: Option<Token>,
//     pub choice: Option<Choice>,
//     pub children: Vec<Node>,
// }

// #[derive(Debug, Clone, PartialEq)]
// pub struct AbstractSyntaxTree {
//     pub root: Node,
// }

// impl GrammarElements {
//     fn is_non_terminal(&self) -> bool {
//         match self {
//             GrammarElements::Start => true,
//             GrammarElements::Term => true,
//             GrammarElements::Loop => true,
//             GrammarElements::Action => true,
//             _ => false,
//         }
//     }
// }

// fn init_ast() -> AbstractSyntaxTree {
//     let ast = AbstractSyntaxTree {
//             root: Node{
//                 grammar_type: GrammarElements::Start,
//                 token: None,
//                 choice: None,
//                 children: Vec::new(),
//             }
//         };
//     ast
// }

// fn init_rules() -> HashMap<GrammarElements, Vec<Vec<GrammarElements>>> {
//     let mut rules: HashMap<GrammarElements, Vec<Vec<GrammarElements>>> = HashMap::new();
    
//     // Start Symbol (Term | epsilon)
//     rules.insert(
//         GrammarElements::Start,
//         vec![
//             vec![GrammarElements::Term],
//             vec![], // epsilon
//         ]
//     );
    
//     // Term Rules (Action Term | Loop Term | Action | Loop)
//     rules.insert(
//         GrammarElements::Term,
//         vec![
//             vec![GrammarElements::Action, GrammarElements::Term],
//             vec![GrammarElements::Loop, GrammarElements::Term],
//             vec![GrammarElements::Action],
//             vec![GrammarElements::Loop],
//             vec![], // epsilon
//         ]
//     );

//     // Loop Rules (OpenBracket Term CloseBracket)
//     rules.insert(
//         GrammarElements::Loop,
//         vec![
//             vec![
//                 GrammarElements::Terminal(TokenTypes::OpenBracket),
//                 GrammarElements::Term,
//                 GrammarElements::Terminal(TokenTypes::CloseBracket)
//             ],
//         ]
//     );

//     // Action Rules (Plus | Minus | Left | Right | Dot | Comma)
//     rules.insert(
//         GrammarElements::Action,
//         vec![
//             vec![
//                 GrammarElements::Terminal(TokenTypes::Plus),
//                 GrammarElements::Terminal(TokenTypes::Minus),
//                 GrammarElements::Terminal(TokenTypes::Left),
//                 GrammarElements::Terminal(TokenTypes::Right),
//                 GrammarElements::Terminal(TokenTypes::Dot),
//                 GrammarElements::Terminal(TokenTypes::Comma),
//             ],
//         ]
//     );
//     rules
// }

// pub fn parse(file_lex: Vec<Token>) -> AbstractSyntaxTree {
//     let mut ast: AbstractSyntaxTree = init_ast();
//     let mut focus: GrammarElements = GrammarElements::Start;
//     let mut stack: Vec<GrammarElements> = Vec::new();
//     let _rules: HashMap<GrammarElements, Vec<Vec<GrammarElements>>> = init_rules();

//     let mut iterator: i32 = 0;
//     let eof: usize = file_lex.len();
//     let mut picked: usize = 0;
//     let mut max: usize = 0;

//     loop {
//         if focus.is_non_terminal() {
//             max = _rules.get(&focus).unwrap().len();
//             let mut rules = _rules.get(&focus).unwrap();
//             let mut rule = &rules[picked];

//             for expr in rule.iter().rev() {
//                 stack.push(*expr);
//             }

            
//             println!("{:?}", rule);
//         } else if true {

//         }

//         break
//     }

//     ast
// }