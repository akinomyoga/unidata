#!/bin/bash

output=gencat.js
{
  cat <<EOF
var GetUnicodeGeneralCategory=(function(){
  // from UNIDATA/UnicodeData.txt $(date  -r UNIDATA/UnicodeData.txt +'%Y-%m-%d %H:%M:%S')
  var table=[
EOF
  awk '
  {
    if(NR==1){
      printf("    ");
    }else if((NR-1)%16==0){
      printf(",\n    ");
    }else{
      printf(",");
    }
    # printf("%s","{code:0x" $1 ",cat:\"" $3 "\"}");
    printf("%s","[" strtonum("0x" $1) ",\"" $3 "\"]");
  }
  END{print "";}
' GenCatTable.txt

  cat <<EOF
  ];

  var cache={};
  
  return function(code){
    // binary search
    if(code<0||0x110000<=code)return "Cn";
    if(code in cache)return cache[code];
  
    var il=0,iu=table.length;
    while(il+1<iu){
      var im=(il+iu)/2;
      if(table[im][0]<=code)
        il=im;
      else
        iu=im;
      // assert(table[il].code<=code&&code<table[iu].code);
    }
  
    return cache[code]=table[il][1];
  }
})();

EOF
} > "$output"
