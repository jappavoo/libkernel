SECTIONS
  {
  . =  0xffffffff81001000;
  .ktext : { *(.ktext) _ektext = . ; }
}
