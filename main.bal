import ballerina/http;
import rest_service.records;
import ballerina/log;
import rest_service.mysql;

service /movies on new http:Listener(9090) {
    resource function get view(http:Caller caller, http:Request req) {
        records:Movie[] movies = mysql:query();
        http:Response res = new;
        json|error respJson = movies.cloneWithType(json);
        if (respJson is json) {
            res.setJsonPayload(respJson);
        }
        var result = caller->respond(res);
        if (result is error) {
            log:printError("Error when responding", err = result);
        }
    }

    @http:ResourceConfig {consumes: ["application/json"]}
    resource function post insert(http:Caller caller, http:Request req, @http:Payload {} records:Movie movie) {
        var err = mysql:insert(movie);
        http:Response resp = new; 
        if(err is error) {
            resp.statusCode = 500;
            resp.setJsonPayload({"error": "Failed to update movie"});
        } else {
            resp.setJsonPayload("Successfully updated movie");
        }
        var result = caller->respond(resp);
        if (result is error) {
            log:printError("Error when responding", err = result);
        }
    }

    resource function get delete/[string movieName](http:Caller caller, http:Request req) {
        var err = mysql:delete(movieName);
        http:Response resp = new; 
        if(err is error) {
            resp.statusCode = 500;
            resp.setJsonPayload({"error": "Failed to delete movie"});
        } else {
            resp.setJsonPayload("Successfully deleted movie");
        }
        var result = caller->respond(resp);
        if (result is error) {
            log:printError("Error when responding", err = result);
        }
    }
}
