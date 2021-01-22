import ballerina/http;
import ballerina/test;

@test:Config {}
function testSqlQuery() returns error? {
    http:Client cli = check new("http://localhost:9090");
    var resp = cli->get("/movie/view");
    if(resp is http:Response) {

    }
}