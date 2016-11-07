import Kitura
import Web
import SwiftProtobuf


// Create a new router
let router = Router()

var myLibrary = MyLibrary()

router.all("/", middleware: BodyParser())

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
    
    switch acceptType {
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
        response.send("If application/octet-stream, this won't work.")
        next()
        return
    }
    
    let book: BookInfo
    
    switch body {
        case .raw(let raw):       book = try BookInfo.init(protobuf: raw)
        case .json(let json):     book = try BookInfo.init(json: json.rawString()!)
        default: return
    }
    
    myLibrary.books.append(book)
    response.status(.OK).send("Added book \(book.id)")
    next()
    
}


Kitura.addHTTPServer(onPort: 8090, with: router)
Kitura.run()



