import ballerina/http;
import ballerina/test;
import ballerina/io;

@test:Config {}
function testSqlQuery() returns error? {
    http:Client cli = check new("http://localhost:9090");
    var resp = cli->get("/movie/view");
    if(resp is http:Response) {
        io:println(resp.statusCode);
        var msg = resp.getJsonPayload();
        if(msg is json) {
            json expected = [{"title":"Joker", "genre":"psychological thriller", "director":"Todd Phillips", "release_year":2019}];
            test:assertEquals(msg, expected);
        } else {
            test:assertFail("Json expected");
        }
    } else {
        test:assertFail("Invalid response");
    }
}