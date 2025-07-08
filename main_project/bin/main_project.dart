/*
we will make a simple dart project that will be like a metro application
it will ask user for start station and end station
and then it will show the shortest path between them depending on number of stations

first we will declare the 3 lines of metro
second we will ask the user for start and end stations
then we will find the shortest path between them
we will use BFS algorithm to find the shortest path
we will use a map to represent the metro lines and stations
*/
import 'dart:io';
void main(){
//get inputs
  print('Enter start station:');
  final startStation = stdin.readLineSync()!;
  print('Enter end station:');
  final endStation = stdin.readLineSync()!;
//define the metro lines
  final metro_line_1 = <String, List<String>> {"helwan": ["ain helwan"],
  "ain helwan": ["helwan", "helwan university"],
  "helwan university": ["ain helwan", "wadi hof"],
  "wadi hof": ["helwan university", "hadayek helwan"],
  "hadayek helwan": ["wadi hof", "elmaasara"],
  "elmaasara": ["hadayek helwan", "tora elasmant"],
  "tora elasmant": ["elmaasara", "kozzika"],
  "kozzika": ["tora elasmant", "tora elbalad"],
  "tora elbalad": ["kozzika", "sakanat elmaadi"],
  "sakanat elmaadi": ["tora elbalad", "maadi"],
  "maadi": ["sakanat elmaadi", "hadayek elmaadi"],
  "hadayek elmaadi": ["maadi", "dar elsalam"],
  "dar elsalam": ["hadayek elmaadi", "elzahraa"],
  "elzahraa": ["dar elsalam", "mar girgis"],
  "mar girgis": ["elzahraa", "elmalek elsaleh"],
  "elmalek elsaleh": ["mar girgis", "alsayeda zeinab"],
  "alsayeda zeinab": ["elmalek elsaleh", "saad zaghloul"],
  "saad zaghloul": ["alsayeda zeinab", "sadat"],
  "sadat": ["saad zaghloul", "gamal abdel nasser", "mohamed naguib", "opera"],
  "gamal abdel nasser": ["sadat", "orabi", "attaba", "maspero"],
  "orabi": ["gamal abdel nasser", "alshohadaa"],
  "alshohadaa": ["orabi", "ghamra", "masarra", "attaba"],
  "ghamra": ["alshohadaa", "eldemerdash"],
  "eldemerdash": ["ghamra", "manshiet elsadr"],
  "manshiet elsadr": ["eldemerdash", "kobri elqobba"],
  "kobri elqobba": ["manshiet elsadr", "hammamat elqobba"],
  "hammamat elqobba": ["kobri elqobba", "saray elqobba"],
  "saray elqobba": ["hammamat elqobba", "hadayek elzaitoun"],
  "hadayek elzaitoun": ["saray elqobba", "helmeyet elzaitoun"],
  "helmeyet elzaitoun": ["hadayek elzaitoun", "elmatareyya"],
  "elmatareyya": ["helmeyet elzaitoun", "ain shams"],
  "ain shams": ["elmatareyya", "ezbet elnakhl"],
  "ezbet elnakhl": ["ain shams", "elmarg"],
  "elmarg": ["ezbet elnakhl", "new elmarg"],
  "new elmarg": ["elmarg"]};

  final metro_line_2 = <String, List<String>> {"shubra elkheima": ["kolleyyet elzeraa"],
  "kolleyyet elzeraa": ["shubra elkheima", "mezallat"],
  "mezallat": ["kolleyyet elzeraa", "khalafawy"],
  "khalafawy": ["mezallat", "st. teresa"],
  "st. teresa": ["khalafawy", "rod elfarag"],
  "rod elfarag": ["st. teresa", "masarra"],
  "masarra": ["rod elfarag", "alshohadaa"],
  "alshohadaa": ["masarra", "orabi", "attaba", "ghamra"],
  "attaba": ["alshohadaa", "mohamed naguib", "bab elshaariya", "gamal abdel nasser"],
  "mohamed naguib": ["attaba", "sadat"],
  "opera": ["sadat", "dokki"],
  "dokki": ["opera", "el bohoth"],
  "el bohoth": ["dokki", "cairo university"],
  "cairo university": ["el bohoth", "faisal", "boulak el dakrour"],
  "faisal": ["cairo university", "giza"],
  "giza": ["faisal", "omm elmasryeen"],
  "omm elmasryeen": ["giza", "sakiat mekky"],
  "sakiat mekky": ["omm elmasryeen", "elmounib"],
  "elmounib": ["sakiat mekky"]};

  final metro_line_3 = <String, List<String>> {"adly mansour": ["elhaykestep"],
  "elhaykestep": ["adly mansour", "omar ibn elkhattab"],
  "omar ibn elkhattab": ["elhaykestep", "qubaa"],
  "qubaa": ["omar ibn elkhattab", "hesham barakat"],
  "hesham barakat": ["qubaa", "elnozha"],
  "elnozha": ["hesham barakat", "el shams club"],
  "el shams club": ["elnozha", "alf masken"],
  "alf masken": ["el shams club", "heliopolis"],
  "heliopolis": ["alf masken", "haroun"],
  "haroun": ["heliopolis", "alahram"],
  "alahram": ["haroun", "koleyet elbanat"],
  "koleyet elbanat": ["alahram", "stadium"],
  "stadium": ["koleyet elbanat", "fair zone"],
  "fair zone": ["stadium", "abbassiya"],
  "abbassiya": ["fair zone", "abdou pasha"],
  "abdou pasha": ["abbassiya", "elgeish"],
  "elgeish": ["abdou pasha", "bab elshaariya"],
  "bab elshaariya": ["elgeish", "attaba"],
  "attaba": ["bab elshaariya", "gamal abdel nasser", "mohamed naguib", "alshohadaa"],
  "gamal abdel nasser": ["attaba", "sadat", "orabi", "maspero"],
  "maspero": ["gamal abdel nasser", "safaa hijazy"],
  "safaa hijazy": ["maspero", "kit kat"],
  "kit kat": ["safaa hijazy", "sudan"],
  "sudan": ["kit kat", "imbaba"],
  "imbaba": ["sudan", "elbohy"],
  "elbohy": ["imbaba", "elqawmia"],
  "elqawmia": ["elbohy", "ring road"],
  "ring road": ["elqawmia", "rod elfarag corridor"],
  "rod elfarag corridor": ["ring road", "tawfikia"],
  "tawfikia": ["rod elfarag corridor", "wadi el nile"],
  "wadi el nile": ["tawfikia", "gamet el dowal"],
  "gamet el dowal": ["wadi el nile", "boulak el dakrour"],
  "boulak el dakrour": ["gamet el dowal", "cairo university"],
  "cairo university": ["boulak el dakrour", "el bohoth", "faisal"]};

//create a graph that contains all the metro lines
  Map<String, List<String>> graph = {};
  graph.addAll(metro_line_1);
  graph.addAll(metro_line_2);
  graph.addAll(metro_line_3);

}