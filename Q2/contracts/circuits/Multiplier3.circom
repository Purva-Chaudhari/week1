pragma circom 2.0.0;

// [assignment] Modify the circuit below to perform a multiplication of three signals
template Multiplier2 () {  

   // Declaration of signals.  
   signal input a;  
   signal input b;  
   signal output c;  

   // Constraints.  
   c <== a * b;  
}

template Multiplier3 () {  

   // Declaration of signals.  
   signal input a;  
   signal input b;
   signal input c;
   signal output d;  
   component ab = Multiplier2();
   component abc = Multiplier2();

   //Statements.
   ab.a <== a;
   ab.b <== b;
   abc.a <== ab.c;
   abc.b <== c;
   d <== abc.c;  
}

component main = Multiplier3();