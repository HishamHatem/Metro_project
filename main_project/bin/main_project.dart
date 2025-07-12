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

List<List<String>> bfs(Map<String, List<String>> graph, String start, String end) {
  Queue<List<String>> queue = Queue<List<String>>();
  List<List<String>> allPaths = [];

  queue.add([start]);

  while (queue.isNotEmpty ) {
    List<String> path = queue.removeFirst();
    String current = path.last;
    
    if (current == end) {
      allPaths.add(path);
      continue; // Continue to find more paths
    }
    
    List<String> neighbors = graph[current] ?? [];

    // Create a copy and remove line identifier safely
    List<String> actualNeighbors = neighbors.length > 1 ? neighbors.sublist(1) : [];

    for (String neighbor in actualNeighbors) {
      // Only visit if not already in current path
      if (!path.contains(neighbor)) {
        List<String> newPath = List.from(path);
        newPath.add(neighbor);
        queue.add(newPath);
      }
    }
  }
  
  // Sort paths by length (shortest first)
  allPaths.sort((a, b) => a.length.compareTo(b.length));
  
  return allPaths;
} 

void main(){
//define the metro lines
  final metro_line_1 = <String, List<String>> {
    "helwan": ["line_1", "ain helwan"],
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
    "new elmarg": ["line_1", "elmarg"]
  };

  final metro_line_2 = <String, List<String>> {
    "shubra elkheima": ["line_2", "kolleyyet elzeraa"],
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
    "elmounib": ["line_2", "sakiat mekky"]
  };

  final metro_line_3 = <String, List<String>> {
    "adly mansour": ["line_3", "elhaykestep"],
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
    "cairo university": ["line_3", "boulak el dakrour", "el bohoth", "faisal"]
  };
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
    if(bestMatch != null){
      print("Did you mean ${bestMatch.bestMatch.target}? enter 'yes' if you mean this: ");
      answer = stdin.readLineSync()!;
      if (answer == 'yes'){
        startStation = bestMatch.bestMatch.target as String;
      } else {
        print("No similar station found");
        return ;
      }
    }
  }

  print('Enter end station:');
  String endStation = stdin.readLineSync()!;
  bestMatch = endStation.bestMatch(allStations);
  if(!metro_line_1.containsKey(endStation) && !metro_line_2.containsKey(endStation) && !metro_line_3.containsKey(endStation)){
    print("Wrong station name");
    if(bestMatch != null){
      print("Did you mean ${bestMatch.bestMatch.target}? enter 'yes' if you mean this: ");
      answer = stdin.readLineSync()!;
      if (answer == 'yes'){
        endStation = bestMatch.bestMatch.target as String;
      } else {
        print("No similar station found");
        return ;
      }
    }
  }

//create a graph that contains all the metro lines
  Map<String, List<String>> graph = {};
  graph.addAll(metro_line_1);
  graph.addAll(metro_line_2);
  graph.addAll(metro_line_3);
  
  final result = bfs(graph, startStation, endStation);
  if (result.isEmpty) {
    print("No path found between $startStation and $endStation.");
  } else {
    print("All possible paths from $startStation to $endStation:");
    for (var path in result) {
      final numberOfStations = path.length;
      final totalMinutes = numberOfStations * 2; //total minutes taken from start station to end station in this path
      final int hours = totalMinutes ~/ 60;
      final minutes = totalMinutes % 60;
      int ticket;
      if(numberOfStations <= 9){
        ticket = 8; //first exception that ticket price starts from 8 L.E. then 10 L.E. then adds 5 L.E. every 7 stations
      } else if (numberOfStations > 23){
        ticket = 20; //second exception that ticket price is capped at 20 L.E.
      } else {
        ticket = 10 + 5*((numberOfStations - 9) ~/ 7); //every 7 stations over 9 stations adds 5 L.E.
      }

      if(path == result[0]){
        print("Shortest Path: ");
      }
      print(path.join(" -> "));
      print("number of stations: $numberOfStations stations, and ticket cost = $ticket L.E.");
      if(hours!=0){
        print("time taken in this path: $hours hours and $minutes minutes");
      }
      else{
        print("time taken in this path: $totalMinutes minutes");
      }
      print("");
    }

  }

}

//el bohoth
//abdou pasha