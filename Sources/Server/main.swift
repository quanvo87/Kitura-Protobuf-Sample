import Kitura
import Web
import Protobuf

// Create a new router
let router = Router()

// Handle HTTP GET requests to /
router.get("/v1/book/protobuf") {
    request, response, next in
    
    let b = BookInfo(id: 303, title: "The Odyssey", author: "Homer")
    
    let data = try b.serializeProtobuf()
    let jsonBook = try b.serializeJSON()
    
    response.send(data: data)
    
    // response.send("Hello, World!")

    next()
}

router.get("/v1/book/json") {
    request, response, next in
    
    let b = BookInfo(id: 303, title: "The Odyssey", author: "Homer")
    
    let jsonBook = try b.serializeJSON()

    response.send(jsonBook)
    
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
    
}


// Add an HTTP server and connect it to the router
Kitura.addHTTPServer(onPort: 8090, with: router)

// Start the Kitura runloop (this call never returns)
Kitura.run()



