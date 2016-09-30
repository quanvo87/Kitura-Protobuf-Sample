import Kitura
import Web
import Protobuf

// Create a new router
let router = Router()

var myLibrary = MyLibrary()

// Handle HTTP GET requests to /
router.get("/v1/book") {
    request, response, next in
    
    let b = BookInfo(id: 303, title: "The Odyssey", author: "Homer")
    
    guard let acceptType = request.headers["Accept"] else {
        let jsonBook = try b.serializeJSON()
        response.send(jsonBook)
        next()
        return
    }
    
    switch request.headers["Accept"]! {
        case "application/json":
            let jsonBook = try b.serializeJSON()
            response.send(jsonBook)
        case "application/octet-stream":
            let data = try b.serializeProtobuf()
            response.send(data: data)
        default:
            let jsonBook = try b.serializeJSON()
            response.send(jsonBook)
    }

    next()
}

router.post("/v1/book") {
    request, response, next in
    
    guard let contentType = request.headers["Content-Type"] else {
        response.status(.badRequest)
        next()
        return
    }
    
    guard let body = request.body else {
        next()
        return
    }
    
    let book: BookInfo
    
    switch body {
        case .raw(let raw):       book = try BookInfo.init(protobuf: raw)
        case .text(let json):     book = try BookInfo.init(json: json)
        default: return
    }
    
    myLibrary.books.append(book)
    
}


Kitura.addHTTPServer(onPort: 8090, with: router)
Kitura.run()



