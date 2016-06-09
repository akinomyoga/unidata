#!/usr/bin/gawk -f

BEGIN{
  FS=";";
  GenCat="";
  mode=0;
}

function error_exit(msg){
  print "error: " msg >"/dev/stderr"
  exit
}

function output_range(){
  if(GenCat!="")
    printf("%x %x %s\n",ch0,chN,GenCat);
  if(code>chN)
    printf("%x %x %s\n",chN,code,"Cn");
}

function get_type(){
  #return "C"
  return $3;
}

$2~/Last>/{
  code=strtonum("0x" $1);
  cat=get_type();

  if(mode!=1)
    error_exit("<..., First> is expected.");
  if(GenCat!=cat)
    error_exit("GenCat of First/Last is different!");

  chN=code+1;

  mode=0;
  next;
}

{
  code=strtonum("0x" $1);
  cat=get_type();

  if(mode==1)
    error_exit("<..., Last> is expected.");

  if(code>chN||GenCat!=cat){
    output_range();
    ch0=code;
    GenCat=cat;
  }
  chN=code+1;

  if($2~/First>/)
    mode=1;
}

END{
  code=0x110000;
  output_range();
}
