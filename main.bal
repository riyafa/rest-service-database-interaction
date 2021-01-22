import ballerina/http;
import rest_service.records;
import ballerina/log;
import rest_service.mysql;

service /movies on new http:Listener(9090) {
    resource function get view(http:Caller caller, http:Request req) {
        records:Movie[] movies = mysql:query();
        http:Response res = new;
        json|error respJson = movies.cloneWithType(json);
        if(respJson is json) {
            res.setJsonPayload(respJson);
        }
        var result = caller->respond(res);
        if(result is error) {
            log:printError("Error when responding", err = result);
        }
    }
}

