pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/comparators.circom";
include "../../node_modules/circomlib-matrix/circuits/matMul.circom";
include "../../node_modules/circomlib-matrix/circuits/transpose.circom";
 // hint: you can use more than one templates in circomlib-matrix to help you

template SystemOfEquations(n) { // n is the number of variables in the system of equations
    signal input x[n]; // this is the solution to the system of equations
    signal input A[n][n]; // this is the coefficient matrix
    signal input b[n]; // this are the constants in the system of equations
    signal output out; // 1 for correct solution, 0 for incorrect solution

    // [bonus] insert your code here
    // Calculate A*x
    component Ax = matMul(n,n,1);
    for (var i=0; i<n; i++){
        for (var j=0; j<n; j++){
            Ax.a[i][j] <== A[i][j];
        }
        Ax.b[i][0] <== x[i];
    }
    
    // Boolean array to equate our calculated A*x with the constants array b 
    component bool[n];
    for (var i=0; i<n; i++){
        bool[i] = IsEqual();
        bool[i].in[0] <== b[i];
        bool[i].in[1] <== Ax.out[i][0];
    }
    
    // Multiplication of one dimensional matrix of ones with its transpose 
    // should be equal to n 
    // i.e Mat(1xn) x Mat'(nx1) will give (1x1) output matrix with the element n
    component trans = transpose(n,1);
    for (var i=0; i<n; i++) {
        trans.a[i][0] <== bool[i].out;
    }
    
    // 
    component sumN = matMul(1,n,1);
    for (var i=0; i<n; i++){
        sumN.a[0][i] <== trans.out[0][i];
        sumN.b[i][0] <== bool[i].out;
    }

    component eq = IsEqual();
    eq.in[0] <== sumN.out[0][0];
    eq.in[1] <== n;

    out <== eq.out;
}

component main {public [A, b]} = SystemOfEquations(3);