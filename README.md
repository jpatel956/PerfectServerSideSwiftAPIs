# PerfectServerSideSwiftAPIs
Provide sample that demostrate how to create basic apis using server side swift.


•    Get service

    Service request: localhost:8080/hello
    Response : {"message":"Hi, Jatin"}

•    Get service with parameters in url

    Service request: localhost:8080/beers/100
    Response : {"message":"There are 100 beers are in bar."}    

•    POST service with parameters

    Service request: localhost:8080/post
    Body : {"name":"Jay ganeshay Namah"}


Additional to normal request. Here I am providing file upload sample with multipart request.


•    POST service with parameters and file upload with multipart

    Service request: localhost:8080/registration
    Body : {"email":"xyz@gmail.com"} and pass any file using multipart
    Response : {"message":"Your email is xyz@gmail.com"}    

