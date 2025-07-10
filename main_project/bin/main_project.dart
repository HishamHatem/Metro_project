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

List<List<String>> bfs(Map<String, List<String>> graph, String start, String end) {
  Queue<List<String>> queue = Queue<List<String>>();
  List<List<String>> allPaths = [];

  // Start with just the station name
  queue.add([start]);

  while (queue.isNotEmpty) {
    List<String> path = queue.removeFirst();
    String current = path.last;
    
    if (current == end) {
      allPaths.add(path);
      continue;
    }
    
    List<String> neighbors = graph[current] ?? [];
    List<String> actualNeighbors = neighbors.length > 1 ? neighbors.sublist(1) : [];
    String lineNumber = neighbors.isNotEmpty ? neighbors[0] : "";

    for (String neighbor in actualNeighbors) {
      // Check if neighbor station is already in path (check only odd indices for stations)
      bool alreadyVisited = false;
      for (int i = 0; i < path.length; i += 2) {
        if (path[i] == neighbor) {
          alreadyVisited = true;
          break;
        }
      }
      
      if (!alreadyVisited) {
        List<String> newPath = List.from(path);
        newPath.add(lineNumber);  // Add line number
        newPath.add(neighbor);    // Add station name
        queue.add(newPath);
      }
    }
  }
  //odd --> line number
  //even --> station name
  allPaths.sort((a, b) => a.length.compareTo(b.length));
  return allPaths;
}

// still don't add the transaction stations
void printPaths(List<List<String>> paths) {
  if (paths.isEmpty) {
    print("No path found.");
    return;
  }
  
  print("All possible paths:");
  for (int pathIndex = 0; pathIndex < paths.length; pathIndex++) {
    var path = paths[pathIndex];
    print("\nPath ${pathIndex + 1}:");
    
    if (path.length == 1) {
      print("You are already at ${path[0]}");
      continue;
    }
    
    // Start station (no line info)
    print("Start from: ${path[0]}");
    
    String? previousLine; // this variable can be null
    
    // Process stations with lines (from index 1 onwards)
    for (int i = 1; i < path.length; i += 2) {
      if (i + 1 < path.length) {
        String currentLine = path[i];     // Line number
        String currentStation = path[i + 1]; // Station name
        
        if (previousLine == null || previousLine != currentLine) {
          print("Take $currentLine to $currentStation");
        } else {
          print("Continue to $currentStation");
        }
        
        previousLine = currentLine;
      }
    }
    
    print("Arrive at: ${path.last}");
    print("Total stations: ${(path.length + 1) ~/ 2}");
  }
}
void main(){
//get inputs
  print('Enter start station:');
  final startStation = stdin.readLineSync()!;
  print('Enter end station:');
  final endStation = stdin.readLineSync()!;
//define the metro lines
  final metro_line_1 = <String, List<String>> {"helwan": ["line_1", "ain helwan"],
  "ain helwan": ["line_1", "helwan", "helwan university"],
  "helwan university": ["line_1", "ain helwan", "wadi hof"],
  "wadi hof": ["line_1", "helwan university", "hadayek helwan"],
  "hadayek helwan": ["line_1", "wadi hof", "elmaasara"],
  "elmaasara": ["line_1", "hadayek helwan", "tora elasmant"],
  "tora elasmant": ["line_1", "elmaasara", "kozzika"],
  "kozzika": ["line_1", "tora elasmant", "tora elbalad"],
  "tora elbalad": ["line_1", "kozzika", "sakanat elmaadi"],
  "sakanat elmaadi": ["line_1", "tora elbalad", "maadi"],
  "maadi": ["line_1", "sakanat elmaadi", "hadayek elmaadi"],
  "hadayek elmaadi": ["line_1", "maadi", "dar elsalam"],
  "dar elsalam": ["line_1", "hadayek elmaadi", "elzahraa"],
  "elzahraa": ["line_1", "dar elsalam", "mar girgis"],
  "mar girgis": ["line_1", "elzahraa", "elmalek elsaleh"],
  "elmalek elsaleh": ["line_1", "mar girgis", "alsayeda zeinab"],
  "alsayeda zeinab": ["line_1", "elmalek elsaleh", "saad zaghloul"],
  "saad zaghloul": ["line_1", "alsayeda zeinab", "sadat"],
  "sadat": ["line_1", "saad zaghloul", "gamal abdel nasser", "mohamed naguib", "opera"],
  "gamal abdel nasser": ["line_1", "sadat", "orabi", "attaba", "maspero"],
  "orabi": ["line_1", "gamal abdel nasser", "alshohadaa"],
  "alshohadaa": ["line_1", "orabi", "ghamra", "masarra", "attaba"],
  "ghamra": ["line_1", "alshohadaa", "eldemerdash"],
  "eldemerdash": ["line_1", "ghamra", "manshiet elsadr"],
  "manshiet elsadr": ["line_1", "eldemerdash", "kobri elqobba"],
  "kobri elqobba": ["line_1", "manshiet elsadr", "hammamat elqobba"],
  "hammamat elqobba": ["line_1", "kobri elqobba", "saray elqobba"],
  "saray elqobba": ["line_1", "hammamat elqobba", "hadayek elzaitoun"],
  "hadayek elzaitoun": ["line_1", "saray elqobba", "helmeyet elzaitoun"],
  "helmeyet elzaitoun": ["line_1", "hadayek elzaitoun", "elmatareyya"],
  "elmatareyya": ["line_1", "helmeyet elzaitoun", "ain shams"],
  "ain shams": ["line_1", "elmatareyya", "ezbet elnakhl"],
  "ezbet elnakhl": ["line_1", "ain shams", "elmarg"],
  "elmarg": ["line_1", "ezbet elnakhl", "new elmarg"],
  "new elmarg": ["line_1", "elmarg"]};

  final metro_line_2 = <String, List<String>> {"shubra elkheima": ["line_2", "kolleyyet elzeraa"],
  "kolleyyet elzeraa": ["line_2", "shubra elkheima", "mezallat"],
  "mezallat": ["line_2", "kolleyyet elzeraa", "khalafawy"],
  "khalafawy": ["line_2", "mezallat", "st. teresa"],
  "st. teresa": ["line_2", "khalafawy", "rod elfarag"],
  "rod elfarag": ["line_2", "st. teresa", "masarra"],
  "masarra": ["line_2", "rod elfarag", "alshohadaa"],
  "alshohadaa": ["line_2", "masarra", "orabi", "attaba", "ghamra"],
  "attaba": ["line_2", "alshohadaa", "mohamed naguib", "bab elshaariya", "gamal abdel nasser"],
  "mohamed naguib": ["line_2", "attaba", "sadat"],
  "opera": ["line_2", "sadat", "dokki"],
  "dokki": ["line_2", "opera", "el bohoth"],
  "el bohoth": ["line_2", "dokki", "cairo university"],
  "cairo university": ["line_2", "el bohoth", "faisal", "boulak el dakrour"],
  "faisal": ["line_2", "cairo university", "giza"],
  "giza": ["line_2", "faisal", "omm elmasryeen"],
  "omm elmasryeen": ["line_2", "giza", "sakiat mekky"],
  "sakiat mekky": ["line_2", "omm elmasryeen", "elmounib"],
  "elmounib": ["line_2", "sakiat mekky"]};

  final metro_line_3 = <String, List<String>> {"adly mansour": ["line_3", "elhaykestep"],
  "elhaykestep": ["line_3", "adly mansour", "omar ibn elkhattab"],
  "omar ibn elkhattab": ["line_3", "elhaykestep", "qubaa"],
  "qubaa": ["line_3", "omar ibn elkhattab", "hesham barakat"],
  "hesham barakat": ["line_3", "qubaa", "elnozha"],
  "elnozha": ["line_3", "hesham barakat", "el shams club"],
  "el shams club": ["line_3", "elnozha", "alf masken"],
  "alf masken": ["line_3", "el shams club", "heliopolis"],
  "heliopolis": ["line_3", "alf masken", "haroun"],
  "haroun": ["line_3", "heliopolis", "alahram"],
  "alahram": ["line_3", "haroun", "koleyet elbanat"],
  "koleyet elbanat": ["line_3", "alahram", "stadium"],
  "stadium": ["line_3", "koleyet elbanat", "fair zone"],
  "fair zone": ["line_3", "stadium", "abbassiya"],
  "abbassiya": ["line_3", "fair zone", "abdou pasha"],
  "abdou pasha": ["line_3", "abbassiya", "elgeish"],
  "elgeish": ["line_3", "abdou pasha", "bab elshaariya"],
  "bab elshaariya": ["line_3", "elgeish", "attaba"],
  "attaba": ["line_3", "bab elshaariya", "gamal abdel nasser", "mohamed naguib", "alshohadaa"],
  "gamal abdel nasser": ["line_3", "attaba", "sadat", "orabi", "maspero"],
  "maspero": ["line_3", "gamal abdel nasser", "safaa hijazy"],
  "safaa hijazy": ["line_3", "maspero", "kit kat"],
  "kit kat": ["line_3", "safaa hijazy", "sudan"],
  "sudan": ["line_3", "kit kat", "imbaba"],
  "imbaba": ["line_3", "sudan", "elbohy"],
  "elbohy": ["line_3", "imbaba", "elqawmia"],
  "elqawmia": ["line_3", "elbohy", "ring road"],
  "ring road": ["line_3", "elqawmia", "rod elfarag corridor"],
  "rod elfarag corridor": ["line_3", "ring road", "tawfikia"],
  "tawfikia": ["line_3", "rod elfarag corridor", "wadi el nile"],
  "wadi el nile": ["line_3", "tawfikia", "gamet el dowal"],
  "gamet el dowal": ["line_3", "wadi el nile", "boulak el dakrour"],
  "boulak el dakrour": ["line_3", "gamet el dowal", "cairo university"],
  "cairo university": ["line_3", "boulak el dakrour", "el bohoth", "faisal"]};

//create a graph that contains all the metro lines
  Map<String, List<String>> graph = {};
  graph.addAll(metro_line_1);
  graph.addAll(metro_line_2);
  graph.addAll(metro_line_3);
  
  final result = bfs(graph, startStation, endStation);
  printPaths(result);
  
  // for(var entry in graph.entries) print('${entry.key}: ${entry.value}');

}

//el bohoth
//abdou pasha
//mohamed naguib