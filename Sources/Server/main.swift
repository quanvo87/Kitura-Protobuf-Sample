import Kitura
import Web

// Create a new router
let router = Router()

// Handle HTTP GET requests to /
router.get("/protobuf") {
    request, response, next in
    
    let b = BookInfo(id: 303, title: "The Odyssey", author: "Homer")
    
    let data = try b.serializeProtobuf()
    let jsonBook = try b.serializeJSON()
    
    response.send(data: data)
    
    // response.send("Hello, World!")

    next()
}

router.get("/json") {
    request, response, next in
    
    let b = BookInfo(id: 303, title: "The Odyssey", author: "Homer")
    
    let jsonBook = try b.serializeJSON()

    response.send(jsonBook)
    
    next()

}


// Add an HTTP server and connect it to the router
Kitura.addHTTPServer(onPort: 8090, with: router)

// Start the Kitura runloop (this call never returns)
Kitura.run()



