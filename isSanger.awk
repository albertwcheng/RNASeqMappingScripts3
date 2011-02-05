     # ord.awk --- do ord and chr
     
     # Global identifiers:
     #    _ord_:        numerical values indexed by characters
     #    _ord_init:    function to initialize _ord_
     
     
     BEGIN    { _ord_init();  }
     
     function _ord_init(    low, high, i, t)
     {
         low = sprintf("%c", 7) # BEL is ascii 7
         if (low == "\a") {    # regular ascii
             low = 0
             high = 127
         } else if (sprintf("%c", 128 + 7) == "\a") {
             # ascii, mark parity
             low = 128
             high = 255
         } else {        # ebcdic(!)
             low = 0
             high = 255
         }
     
         for (i = low; i <= high; i++) {
             t = sprintf("%c", i)
             _ord_[t] = i
         }
     }
     
     
     function ord(str, where)
     {
         # only first character is of interest
         c = substr(str, where, 1)
         return _ord_[c]
     }
     

     (FNR%4==0){
     	
        for(i=1;i<length($0);i++)
        {
        	ordValue=ord($0,i)
        	if(ordValue<59 || ordValue>104 )
        	{
        		printf "Sanger:[%d=%s],%s\n",ordValue,substr($0,i,1),$0;	
        		break;
        	}
        	
        }	
     	
     	
     }