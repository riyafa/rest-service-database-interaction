import ballerina/http;
import ballerina/test;

@test:Config {}
function testSqlQuery() returns error? {
    http:Client cli = check new ("http://localhost:9090");
    var resp = cli->get("/movies/view", targetType = json);
    if (resp is json) {
        json expected = {
            "title": "Joker",
            "genre": "psychological thriller",
            "director": "Todd Phillips",
            "release_year": 2019
        };
        if (resp is json[]) {
            test:assertEquals(resp[0], expected);
        } else {
            test:assertFail("Invalid message");
        }
    } else {
        test:assertFail("Invalid response");
    }
}

@test:Config {}
function testSqlInsert() returns error? {
    http:Client cli = check new ("http://localhost:9090");
    var resp = cli->post("/movies/insert", message = {"title":"xyz", "genre":"good one", "director":"Todd Phillips", "release_year":2019},targetType = json);
    if (resp is json) {
        json expected = "Successfully updated movie";
        test:assertEquals(resp, expected);
    } else {
        test:assertFail("Invalid response");
    }
}
