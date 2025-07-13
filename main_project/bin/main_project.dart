/*
we will make a simple dart project that will be like a metro application
it will ask user for start station and end station
and then it will show the shortest path between them depending on number of stations

first we will declare the 3 lines of metro
second we will ask the user for start and end stations
then we will find the shortest path between them
we will use BFS algorithm to find the shortest path
we will use a map to represent the metro lines and stations

new features
shortest path
all possible pathes
explain the lines and the count of stations
expected time 2 min per station if it exceed 60 min show it as hours
cost of the ticket

spiecial
clean code:
fail fast
defensive blocks
check inputs
and performance min conditions and loops and memory

spiecial (not interested in this)

check if the input was wrong use string matrix or regex to check the input
if the input was wrong show a message to the user and ask him to enter the input again


*/

import 'dart:io';
import 'dart:collection';
import 'package:string_similarity/string_similarity.dart';

List<List<String>> findPaths(String start, String end, Map<String, List<String>> graph) {
  Queue<List<String>> queue = Queue<List<String>>();
  List<List<String>> allPaths = [];
  
  // Get the starting line for the start station
  String startLine = graph[start]![0];
  
  // Start with the station and its line
  queue.add([start, startLine]);
  
  while (queue.isNotEmpty) {
    List<String> path = queue.removeFirst();
    String currentStation = path[path.length - 2]; // Last station
    // String currentLine = path[path.length - 1];    // Current line
    
    if (currentStation == end) {
      allPaths.add(path);
      continue;
    }
    
    // Get neighbors for current station
    List<String> stationData = graph[currentStation] ?? [];
    if (stationData.isEmpty) continue;
    
    // Process neighbors (pairs: station, line, station, line, ...)
    for (int i = 1; i < stationData.length; i += 2) {
      if (i + 1 < stationData.length) {
        String neighborStation = stationData[i];
        String neighborLine = stationData[i + 1];
        
        // Check if neighbor is already visited (avoid loops)
        bool alreadyVisited = false;
        for (int j = 0; j < path.length; j += 2) {
          if (path[j] == neighborStation) {
            alreadyVisited = true;
            break;
          }
        }
        
        if (!alreadyVisited) {
          List<String> newPath = List.from(path);
          newPath.add(neighborStation);
          newPath.add(neighborLine);
          queue.add(newPath);
        }
      }
    }
  }
  
  // Sort paths by length (shortest first)
  allPaths.sort((a, b) => a.length.compareTo(b.length));
  return allPaths;
}

//new print function
void printPaths(List<List<String>> paths) {
  if (paths.isEmpty) {
    print("No path found.");
    return;
  }
  int shortest_lines = 100;
  int shortest_path_index = 0;
  for (int pathIndex = 0; pathIndex < paths.length; pathIndex++) {
    var path = paths[pathIndex];
    
    if (pathIndex != 0) {
      print("\nPath ${pathIndex + 1}:");
    } else {
      print("The shortest path according to number of stations is:");
    }

    // Start station
    print("You will start from ${path[0]} in ${path[1]}");
    
    String previousLine = path[1]; // First line
    int totalMinutes = 0;
    int stationCount = 1; // Starting station counts
    int linesCount = 1; // Starting line counts

    // Process the path
    for (int i = 2; i < path.length; i += 2) {
      if (i + 1 < path.length) {
        String currentStation = path[i];
        String currentLine = path[i + 1];
        
        stationCount++;
        
        if (previousLine != currentLine) {
          // Line change - transfer
          print("Continue to $currentStation You will change from $previousLine to $currentLine");
          totalMinutes += 5; // Transfer takes 5 minutes
          linesCount++;
        } else {
          // Same line
          print("Continue to $currentStation in the same line ");
          totalMinutes += 2; // Normal travel takes 2 minutes
        }
        
        previousLine = currentLine;
      }
    }
    
    print("You arrived to your destination ${path[path.length - 2]}");
    
    // Calculate ticket cost
    int ticket;
    if (stationCount <= 9) {
      ticket = 8;
    } else if (stationCount > 23) {
      ticket = 20;
    } else {
      ticket = 10 + 5 * ((stationCount - 9) ~/ 7);
    }
    
    // Display summary
    print("\nTotal stations: $stationCount, Ticket cost: $ticket L.E.");
    
    if (totalMinutes >= 60) {
      int hours = totalMinutes ~/ 60;
      int minutes = totalMinutes % 60;
      print("Average time: $hours hours and $minutes minutes");
    } else {
      print("Average time: $totalMinutes minutes");
    }

    if(linesCount < shortest_lines) {
      shortest_lines = linesCount;
      shortest_path_index = pathIndex;
    }
    
    if (pathIndex < paths.length - 1) {
      print("\n" + "="*50);
    }
  }
  print("\nThe shortest path according to number of lines is Path ${shortest_path_index + 1}, and has ${shortest_lines - 1} transitions.");
}


void main(){
//define the metro lines
  final metro_line_1 = <String, List<String>>{
  "helwan": ["line_1", "ain helwan", "line_1"],
  "ain helwan": ["line_1", "helwan", "line_1", "helwan university", "line_1"],
  "helwan university": ["line_1", "ain helwan", "line_1", "wadi hof", "line_1"],
  "wadi hof": ["line_1", "helwan university", "line_1", "hadayek helwan", "line_1"],
  "hadayek helwan": ["line_1", "wadi hof", "line_1", "elmaasara", "line_1"],
  "elmaasara": ["line_1", "hadayek helwan", "line_1", "tora elasmant", "line_1"],
  "tora elasmant": ["line_1", "elmaasara", "line_1", "kozzika", "line_1"],
  "kozzika": ["line_1", "tora elasmant", "line_1", "tora elbalad", "line_1"],
  "tora elbalad": ["line_1", "kozzika", "line_1", "sakanat elmaadi", "line_1"],
  "sakanat elmaadi": ["line_1", "tora elbalad", "line_1", "maadi", "line_1"],
  "maadi": ["line_1", "sakanat elmaadi", "line_1", "hadayek elmaadi", "line_1"],
  "hadayek elmaadi": ["line_1", "maadi", "line_1", "dar elsalam", "line_1"],
  "dar elsalam": ["line_1", "hadayek elmaadi", "line_1", "elzahraa", "line_1"],
  "elzahraa": ["line_1", "dar elsalam", "line_1", "mar girgis", "line_1"],
  "mar girgis": ["line_1", "elzahraa", "line_1", "elmalek elsaleh", "line_1"],
  "elmalek elsaleh": ["line_1", "mar girgis", "line_1", "alsayeda zeinab", "line_1"],
  "alsayeda zeinab": ["line_1", "elmalek elsaleh", "line_1", "saad zaghloul", "line_1"],
  "saad zaghloul": ["line_1", "alsayeda zeinab", "line_1", "sadat", "line_1"],
  "sadat": ["line_1", "saad zaghloul", "line_1", "gamal abdel nasser", "line_1", "mohamed naguib", "line_2", "opera", "line_2"],
  "gamal abdel nasser": ["line_1", "sadat", "line_1", "orabi", "line_1", "attaba", "line_3", "maspero", "line_3"],
  "orabi": ["line_1", "gamal abdel nasser", "line_1", "alshohadaa", "line_1"],
  "alshohadaa": ["line_1", "orabi", "line_1", "ghamra", "line_1", "masarra", "line_2", "attaba", "line_2"],
  "ghamra": ["line_1", "alshohadaa", "line_1", "eldemerdash", "line_1"],
  "eldemerdash": ["line_1", "ghamra", "line_1", "manshiet elsadr", "line_1"],
  "manshiet elsadr": ["line_1", "eldemerdash", "line_1", "kobri elqobba", "line_1"],
  "kobri elqobba": ["line_1", "manshiet elsadr", "line_1", "hammamat elqobba", "line_1"],
  "hammamat elqobba": ["line_1", "kobri elqobba", "line_1", "saray elqobba", "line_1"],
  "saray elqobba": ["line_1", "hammamat elqobba", "line_1", "hadayek elzaitoun", "line_1"],
  "hadayek elzaitoun": ["line_1", "saray elqobba", "line_1", "helmeyet elzaitoun", "line_1"],
  "helmeyet elzaitoun": ["line_1", "hadayek elzaitoun", "line_1", "elmatareyya", "line_1"],
  "elmatareyya": ["line_1", "helmeyet elzaitoun", "line_1", "ain shams", "line_1"],
  "ain shams": ["line_1", "elmatareyya", "line_1", "ezbet elnakhl", "line_1"],
  "ezbet elnakhl": ["line_1", "ain shams", "line_1", "elmarg", "line_1"],
  "elmarg": ["line_1", "ezbet elnakhl", "line_1", "new elmarg", "line_1"],
  "new elmarg": ["line_1", "elmarg", "line_1"],
};

  final metro_line_2 = <String, List<String>>{
    "shubra elkheima": ["line_2", "kolleyyet elzeraa", "line_2"],
    "kolleyyet elzeraa": ["line_2", "shubra elkheima", "line_2", "mezallat", "line_2"],
    "mezallat": ["line_2", "kolleyyet elzeraa", "line_2", "khalafawy", "line_2"],
    "khalafawy": ["line_2", "mezallat", "line_2", "st. teresa", "line_2"],
    "st. teresa": ["line_2", "khalafawy", "line_2", "rod elfarag", "line_2"],
    "rod elfarag": ["line_2", "st. teresa", "line_2", "masarra", "line_2"],
    "masarra": ["line_2", "rod elfarag", "line_2", "alshohadaa", "line_2"],
    "alshohadaa": ["line_2", "masarra", "line_2", "orabi", "line_1", "attaba", "line_2", "ghamra", "line_1"],
    "attaba": ["line_2", "alshohadaa", "line_2", "mohamed naguib", "line_2", "bab elshaariya", "line_3", "gamal abdel nasser", "line_3"],
    "mohamed naguib": ["line_2", "attaba", "line_2", "sadat", "line_2"],
    "sadat": ["line_2", "mohamed naguib", "line_2", "opera", "line_2", "gamal abdel nasser", "line_1", "saad zaghloul", "line_1"],
    "opera": ["line_2", "sadat", "line_2", "dokki", "line_2"],
    "dokki": ["line_2", "opera", "line_2", "el bohoth", "line_2"],
    "el bohoth": ["line_2", "dokki", "line_2", "cairo university", "line_2"],
    "cairo university": ["line_2", "el bohoth", "line_2", "faisal", "line_2", "boulak el dakrour", "line_3"],
    "faisal": ["line_2", "cairo university", "line_2", "giza", "line_2"],
    "giza": ["line_2", "faisal", "line_2", "omm elmasryeen", "line_2"],
    "omm elmasryeen": ["line_2", "giza", "line_2", "sakiat mekky", "line_2"],
    "sakiat mekky": ["line_2", "omm elmasryeen", "line_2", "elmounib", "line_2"],
    "elmounib": ["line_2", "sakiat mekky", "line_2"],
};

  final metro_line_3 = <String, List<String>>{
    "adly mansour": ["line_3", "elhaykestep", "line_3"],
    "elhaykestep": ["line_3", "adly mansour", "line_3", "omar ibn elkhattab", "line_3"],
    "omar ibn elkhattab": ["line_3", "elhaykestep", "line_3", "qubaa", "line_3"],
    "qubaa": ["line_3", "omar ibn elkhattab", "line_3", "hesham barakat", "line_3"],
    "hesham barakat": ["line_3", "qubaa", "line_3", "elnozha", "line_3"],
    "elnozha": ["line_3", "hesham barakat", "line_3", "el shams club", "line_3"],
    "el shams club": ["line_3", "elnozha", "line_3", "alf masken", "line_3"],
    "alf masken": ["line_3", "el shams club", "line_3", "heliopolis", "line_3"],
    "heliopolis": ["line_3", "alf masken", "line_3", "haroun", "line_3"],
    "haroun": ["line_3", "heliopolis", "line_3", "alahram", "line_3"],
    "alahram": ["line_3", "haroun", "line_3", "koleyet elbanat", "line_3"],
    "koleyet elbanat": ["line_3", "alahram", "line_3", "stadium", "line_3"],
    "stadium": ["line_3", "koleyet elbanat", "line_3", "fair zone", "line_3"],
    "fair zone": ["line_3", "stadium", "line_3", "abbassiya", "line_3"],
    "abbassiya": ["line_3", "fair zone", "line_3", "abdou pasha", "line_3"],
    "abdou pasha": ["line_3", "abbassiya", "line_3", "elgeish", "line_3"],
    "elgeish": ["line_3", "abdou pasha", "line_3", "bab elshaariya", "line_3"],
    "bab elshaariya": ["line_3", "elgeish", "line_3", "attaba", "line_3"],
    "attaba": ["line_3", "bab elshaariya", "line_3", "gamal abdel nasser", "line_3", "mohamed naguib", "line_2", "alshohadaa", "line_2"],
    "gamal abdel nasser": ["line_3", "attaba", "line_3", "sadat", "line_1", "orabi", "line_1", "maspero", "line_3"],
    "maspero": ["line_3", "gamal abdel nasser", "line_3", "safaa hijazy", "line_3"],
    "safaa hijazy": ["line_3", "maspero", "line_3", "kit kat", "line_3"],
    "kit kat": ["line_3", "safaa hijazy", "line_3", "sudan", "line_3", "tawfikia", "line_3"],
    "sudan": ["line_3", "kit kat", "line_3", "imbaba", "line_3"],
    "imbaba": ["line_3", "sudan", "line_3", "elbohy", "line_3"],
    "elbohy": ["line_3", "imbaba", "line_3", "elqawmia", "line_3"],
    "elqawmia": ["line_3", "elbohy", "line_3", "ring road", "line_3"],
    "ring road": ["line_3", "elqawmia", "line_3", "rod elfarag corridor", "line_3"],
    "rod elfarag corridor": ["line_3", "ring road", "line_3"],
    "tawfikia": ["line_3", "kit kat", "line_3", "wadi el nile", "line_3"],
    "wadi el nile": ["line_3", "tawfikia", "line_3", "gamet el dowal", "line_3"],
    "gamet el dowal": ["line_3", "wadi el nile", "line_3", "boulak el dakrour", "line_3"],
    "boulak el dakrour": ["line_3", "gamet el dowal", "line_3", "cairo university", "line_3"],
    "cairo university": ["line_2", "el bohoth", "line_2", "faisal", "line_2", "boulak el dakrour", "line_3"],
};
  final graph = <String,List<String>>{};
  graph.addAll(metro_line_1);
  graph.addAll(metro_line_2);
  graph.addAll(metro_line_3);
// list of all stations
  final allStations = [
    "helwan",
    "ain helwan",
    "helwan university",
    "wadi hof",
    "hadayek helwan",
    "elmaasara",
    "tora elasmant",
    "kozzika",
    "tora elbalad",
    "sakanat elmaadi",
    "maadi",
    "hadayek elmaadi",
    "dar elsalam",
    "elzahraa",
    "mar girgis",
    "elmalek elsaleh",
    "alsayeda zeinab",
    "saad zaghloul",
    "sadat",
    "gamal abdel nasser",
    "orabi",
    "alshohadaa",
    "ghamra",
    "eldemerdash",
    "manshiet elsadr",
    "kobri elqobba",
    "hammamat elqobba",
    "saray elqobba",
    "hadayek elzaitoun",
    "helmeyet elzaitoun",
    "elmatareyya",
    "ain shams",
    "ezbet elnakhl",
    "elmarg",
    "new elmarg",
    "shubra elkheima",
    "kolleyyet elzeraa",
    "mezallat",
    "khalafawy",
    "st. teresa",
    "rod elfarag",
    "masarra",
    "attaba",
    "mohamed naguib",
    "opera",
    "dokki",
    "el bohoth",
    "cairo university",
    "faisal",
    "giza",
    "omm elmasryeen",
    "sakiat mekky",
    "elmounib",
    "adly mansour",
    "elhaykestep",
    "omar ibn elkhattab",
    "qubaa",
    "hesham barakat",
    "elnozha",
    "el shams club",
    "alf masken",
    "heliopolis",
    "haroun",
    "alahram",
    "koleyet elbanat",
    "stadium",
    "fair zone",
    "abbassiya",
    "abdou pasha",
    "elgeish",
    "bab elshaariya",
    "maspero",
    "safaa hijazy",
    "kit kat",
    "sudan",
    "imbaba",
    "elbohy",
    "elqawmia",
    "ring road",
    "rod elfarag corridor",
    "tawfikia",
    "wadi el nile",
    "gamet el dowal",
    "boulak el dakrour"
  ];

  //get inputs
  print('Enter start station:');
  String startStation = stdin.readLineSync()!;
  BestMatch bestMatch = startStation.bestMatch(allStations);
  String answer = '';
  if(!metro_line_1.containsKey(startStation) && !metro_line_2.containsKey(startStation) && !metro_line_3.containsKey(startStation)){
    print("Wrong station name");
    if(bestMatch.bestMatch.target != "" && bestMatch.bestMatch.rating! >= 0.4){
      print("Did you mean ${bestMatch.bestMatch.target}? enter 'yes' if you mean this: ");
      answer = stdin.readLineSync()!;
      if (answer == 'yes'){
        startStation = bestMatch.bestMatch.target as String;
      } else {
        print("No similar station found");
        return ;
      }
    } else {
      print("No similar station found");
      return ;
    }
  }

  print('Enter end station:');
  String endStation = stdin.readLineSync()!;
  bestMatch = endStation.bestMatch(allStations);
  if(!metro_line_1.containsKey(endStation) && !metro_line_2.containsKey(endStation) && !metro_line_3.containsKey(endStation)){
    print("Wrong station name");
    if(bestMatch.bestMatch.target != "" && bestMatch.bestMatch.rating! >= 0.4){
      print("Did you mean ${bestMatch.bestMatch.target}? enter 'yes' if you mean this: ");
      answer = stdin.readLineSync()!;
      if (answer == 'yes'){
        endStation = bestMatch.bestMatch.target as String;
      } else {
        print("No similar station found");
        return ;
      }
    } else {
      print("No similar station found");
      return ;
    }
  }
  if (startStation == endStation) {
    print("You are already at $startStation");
    return;
  }
  final result = findPaths(startStation, endStation,graph);
  printPaths(result);
}
