//: Playground - noun: a place where people can play

import UIKit

let form: [String: Any] = [
    "chatmessage": "fuckoff",
    "chatpassword": false,
    "username": "cat"
]

let whatever = form.map({"\($0)=\($1)"}).joined(separator: "&")

whatever