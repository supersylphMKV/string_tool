//acbbacbcabc
// a,b,c,e
String charInput = 'acbbacbcabc';
String charCurrent = '';
var charSet = ['a','b','c'];
var currentHead = 0;
var currChar;
var mapSet = [
  [1,2,3,4],
  [4,2,1,4],
  [2,4,0,4],
  [1,0,4,4],
];
var pattternFound = true;
var currentSet = '';
var resultSets = <String>[];

class StringResult{
  String result;
  List<String> stackTrace;

  StringResult(this.result,this.stackTrace); 
}

readText(String input)async{
  charInput = input.toLowerCase();
  resultSets = <String>[];
  do {
    //print('start itteration');
    stringItteration();
  } while (pattternFound);
  if(charCurrent == ''){
    charCurrent = '-';
  }
  return StringResult(charCurrent, resultSets);
}

void stringItteration(){
  currentHead = 0;
  charCurrent = '';
  currentSet = '';
  pattternFound = false;
  for(var i=0;i<charInput.length;i++){
    currChar = charInput.substring(i);
    if(charInput.length > 1){
      currChar = charInput.substring(i, i+1);
    }
    var ch = charSet.indexOf(currChar);
    //print(currChar + ', ' + currentHead.toString() + ' (' + charCurrent + ')');
    if(ch > -1){
      //print('character in set');
      if(currentHead == 0){
        //print('begining of set');
        currentSet += currChar;
        currentHead = mapSet[currentHead][ch];
      } else {
        //print('set read ' + currentHead.toString() + ', ' + ch.toString());
        currentHead = mapSet[currentHead][ch];
        if(currentHead < 3){
          //print('set found ' + currentHead.toString());
          charCurrent += charSet[currentHead];
          pattternFound = true;
        } else {
          //print('not a set');
          currentSet += currChar;
          charCurrent += currentSet;
        }
        currentSet = '';
        currentHead = 0;
      }
    } else {
      //print('unknown char');
      currentSet += currChar;
      charCurrent += currentSet;
      currentSet = '';
      currentHead = 0;
    }
  }
  charInput = charCurrent;
  resultSets.add(charCurrent);
}