//: Playground - noun: a place where people can play

import Alamofire

var payload = [
    "username": "rpassage",
    "password": "2Banana2"
]

Alamofire.request(.POST, "http://192.168.200.60/frames.asp")
    .response { (request, response, data, error) -> Void in
        print(request)
        print(response)
        print(data)
        print(error)
}
