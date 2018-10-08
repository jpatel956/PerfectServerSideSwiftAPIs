
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

var server = HTTPServer()
server.serverPort = 8080
server.documentRoot = "webroot"

var routes = Routes()
routes.add(method: .get, uri: "/") { (request, response) in
    response.setBody(string: "first Api call")
        .completed()
}


func returnJSONMessage(message:String, response:HTTPResponse){
    
    do {
        try response.setBody(json: ["message" : message])
            .setHeader(.contentType, value: "text")
            .completed()
    } catch {
        response.setBody(string: "Error occured : \(error)")
            .completed(status: .internalServerError)
    }
}



//Example of Simple Get service
//Service request: localhost:8080/hello
//Response : {"message":"Hi, Jatin"}
routes.add(method: .get, uri: "/hello") { (request, response) in
    returnJSONMessage(message: "Hi, Jatin", response: response)
}



//Example of Simple Get service with parameters in url
//Service request: localhost:8080/beers/100
//Response : {"message":"There are 100 beers are in bar."}
routes.add(method: .get, uri: "beers/{num_beers}") { (request, response) in
    guard let numbeers = request.urlVariables["num_beers"],let numbearInt = Int(numbeers) else {
        response.completed(status: .badRequest)
        return
    }
    returnJSONMessage(message: "There are \(numbearInt) beers are in bar.", response: response)
}



//Example of POST service with parameters
//Service request: localhost:8080/post
// Body : {"name":"Jay ganeshay Namah"}
//Response : {"message":"Hello: Jay ganeshay Namah"}
routes.add(method: .post, uri: "post") { (request, response) in
    guard let name = request.param(name: "name") else {
        response.completed(status: .badRequest)
        return
    }
    returnJSONMessage(message: "Hello: \(name)", response: response)
}


//Example of POST service with parameters and file upload with multipart
//Service request: localhost:8080/registration
// Body : {"email":"xyz@gmail.com"} and pass any file using multipart
//Response : {"message":"Your email is xyz@gmail.com"}
routes.add(method: .post, uri: "registration") { (request, response) in
    
    guard let email = request.param(name:"email") else {
        
        do {
             try response.setBody(json: ["message" : "Email ID is mandatory."])
            
        } catch {
            response.setBody(string: "Error occured : \(error)")
                .completed(status: .internalServerError)
        }
      
        response.completed(status: .badRequest)
        return
    }
    
    // create uploads dir to store files
    let fileDir = Dir(Dir.workingDir.path + "./webroot/files")
    do {
        try fileDir.create()
    } catch {
        print(error)
    }
    
    if let uploads = request.postFileUploads, uploads.count > 0 {

        for upload in uploads {
            let thisFile = File(upload.tmpFileName)
            do {
                let _ = try thisFile.moveTo(path: "./webroot/files/\(upload.fileName)", overWrite: true)
                print("File Path : \(Dir.workingDir.path)")
            } catch {

            }
        }
    }
    else {
        returnJSONMessage(message: "file is mandatorty.", response: response)
    }
    
    returnJSONMessage(message: "Your email is \(email)", response: response)
}

server.addRoutes(routes)

do {
    try server.start()
} catch PerfectError.networkError( _, _){
    print("Network error")
}

