import Kitura
import Web
import SwiftProtobuf
import Foundation


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
    
    let book: BookInfo
    
    switch contentType {
    case "application/octet-stream":
        var data = Data()
        _ = try request.read(into: &data)
        book = try BookInfo.init(protobuf: data)
        break
    case "application/json":
        guard let body = request.body,
            case let .json(data) = body,
            let jsonString = data.rawString() else {
                response.status(.badRequest)
                next()
                return
        }
        book = try BookInfo.init(json: jsonString)
        break
    default:
        response.status(.badRequest)
        next()
        return
    }
    
    myLibrary.books.append(book)
    response.status(.OK).send("Added book \(book.id)")
    next()
    
}


Kitura.addHTTPServer(onPort: 8090, with: router)
Kitura.run()



