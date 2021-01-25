import rest_service.records;
import ballerina/log;
import ballerina/sql;
import ballerinax/mysql;




// Todo: use configurable
string dbUser = "riyafa";
string dbPassword = "";

mysql:Client msClient;

function init() returns error? {
    msClient = check new ("localhost", dbUser, dbPassword);
}

# Query the database
# + return - Return queried movies
public function query() returns records:Movie[] {
    stream<record { }, error> results = msClient->query("SELECT * FROM movies.movies");
    records:Movie[] movies = [];
    error? e = results.forEach(function(record { } result) {
                                   string? genre;
                                   records:Movie movie = {
                                       title: <string>result["title"],
                                       genre: <string?>result["genre"],
                                       director: <string?>result["director"],
                                       release_year: (<int?>result["release_year"]) ?: 0
                                   };
                                   movies[movies.length()] = movie;
                               });
    if (e is error) {
        log:printError("Error retrieving results from db", err = e);
    }
    return movies;
}

# Description
#
# + movie - Parameter Description  
# + return - Return Value Description
public function insert(records:Movie movie) returns error? {
    sql:ParameterizedQuery insQuery = `INSERT INTO movies.movies (title, genre, director, release_year) VALUES (${movie.
    title}, ${movie.genre}, ${movie.director}, ${movie.release_year})`;
    sql:ExecutionResult result = check msClient->execute(insQuery);
}

function stop() returns error? {
    check msClient.close();
}
