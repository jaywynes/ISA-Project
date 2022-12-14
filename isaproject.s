// The code you must implement is provided in ISAproject.pdf

// Define stack start address
.stack 0x5000

// Define address of printf
.text 0x7000
.label printf

.data 0x100
//sum sia is 228
.label sia
50
43
100
-5
-10
50
0
//sum sib is 678
.label sib
500
43
100
-5
-10
50
0
.label fmt1
.string //cmp_arrays(sia, sib): %d
.label fmt2
.string //cmp_arrays(sia, sia): %d
.label fmt3
.string //cmp_arrays(sib, sia): %d
.label fmt4
.string //cmp_arrays(ia, sib): %d
.label fmt5
.string //Something bad
.label fmt6
.string // Nice sort and smallest
.label fmt7
.string //ia[%d]: %d
.label fmt8
.string //sia[%d]: %d
.label fmt9
.string //smallest(ia): %d
.label fmt10
.string //smallest(sia): %d
.label fmt11
.string //factorial(4) is: %d
.label fmt12
.string //factorial(7) is: %d
.text 0x300
// r0 has ia - address of null terminated array
// sum_array is a leaf function
// If you only use r0, r1, r2, r3; you do not need a stack
.label sum_array
mov r1, #0 //s = 0;
ldr r2, [r0] //*ia in r2
cmp r2, #0 //check *ia != 0
beq endwhile1
.label while1
add r1, r1, r2 //s += *ia
add r0, r0, #4 //*ia++
ldr r2, [r0] //put *ia++ in r2
cmp r2, #0 //check *ia != 0
bne while1 //continue looping
.label endwhile1
mov r0, r1 //put s in r0 to return
mov r15, r14       // return

.text 0x400
// r0 has ia1 - address of null terminated array
// r1 has ia2 - address of null terminated array
// cmp_arrays must allocate a stack
// Save lr on stack and allocate space for local vars
.label cmp_arrays
sub r13, r13, #20 //space for ia1, ia2, s1, s2, & lr
str r0, [r13, #0] //ia1
str r1, [r13, #4] //ia2
mov r3, #0
str r3, [r13, #8] //s1
str r3, [r13, #12] //s2
str r14, [r13, #16] //save lr on stack
ldr r0, [r13, #0] //put ia1 in r0
.label bp
blr sum_array
str r0, [r13, #8] //s1 = sum_array(ia1);
ldr r0, [r13, #4] //put ia2 in r0
blr sum_array
str r0, [r13, #12] //s2 = sum_array(ia2);
ldr r0, [r13, #8] //put s1 in r0
ldr r1, [r13, #12] //put s2 in r1
cmp r0, r1
beq cmp_eq    // s1 == s2 ?
bne cmp_neq
.label cmp_eq
mov r0, #0   //put 0 as r0 return if s1 == s2
bal cmp_end
.label cmp_neq
cmp r0, r1  
bgt cmp_gt   //perform s1 < s2 ? if s1 != s2
ble cmp_le
.label cmp_gt
mov r0, #1  //if s1 > s2, r0 return is 1
bal cmp_end
.label cmp_le
mov r0, #-1 //if s1 <= s2, r0 return is -1
bal cmp_end
.label cmp_end
ldr r14, [r13, #16] //restore r14
add r13, r13, #20 //restore r13
mov r15, r14       // return

.text 0x500
// r0 has ia - address of null terminated array
// numelems is a leaf function
// If you only use r0, r1, r2, r3; you do not need a stack
.label numelems
mov r1, #0 // c = 0
.label numelemswhile1
ldr r2, [r0], #4
cmp r2, #0 // check if *ia != 0
beq endnumelemswhile
add r1, r1, #1 //c++
bal numelemswhile1
.label endnumelemswhile
mov r0, r1 //move c to r1
mov r15, r14       // return
//numelems in r1

.text 0x600
// r0 has ia - address of null terminated array
// sort must allocate a stack
// Save lr on stack and allocate space for local vars
.label sort
sub r13, r13, #8 //space for s, lr
mov r3, r0 //move address of ia to r3
blr numelems
str r0, [r13, #0] //s = numelems(ia);
str r14, [r13, #4] //save lr on stack
ldr r1, [r13, #0] //put s in r1
mov r0, r3 //move address of ia back to r0
mov r2, #0 //put i in r2
cmp r2, r1
bge endloop1
.label loop1
mov r3, #0 //put j in r3
sub r4, r1, #1 //s - 1
sub r4, r4, r2 //(s-1)-i
cmp r3, r4 //j < s-1-i
bge endloop2
.label loop2
add r6, r3, #1 //j+1
ldr r5, [r0, r3] //ia[j]
ldr r7, [r0, r6] //ia[j+1]
cmp r5, r7
ble skip1 
mov r8, r5 //put t in r8 = to ia[j]
mov r5, r7 //ia[j] = ia[j+1]
mov r7, r8 //ia[j+1] = t
str r5, [r0, r3] //store new ia[j]
str r7, [r0, r6] //store new ia[j+1]
.label skip1
add r3, r3, #1 //j++
cmp r3, r4 // j < s-1-j
blt loop2
.label endloop2
add r2, r2, #1
cmp r2, r1 // i < s
blt loop1
.label endloop1
ldr r14, [r13, #4] //restore lr
add r13, r13, #8    //restore r13 stack
mov r15, r14       // return - sort is a void function

.text 0x700
// r0 has ia - address of null terminated array
// smallest must allocate a stack
// Save lr on stack and allocate space for local vars
.label smallest
sub r13, r13, #16 //space for s, sm, p, lr
mov r1, r0 //move address of ia to r1
blr numelems
str r0, [r13, #0] //put s on stack
ldr r0, [r1]
str r0, [r13, #4] //put sm on stack
mov r0, #0
str r0, [r13, #8] //put p on stack
str r14, [r13, #12] //save lr on stack
ldr r0, [r13, #4] //put sm in r1
ldr r2, [r13, #8] //put p in r2
ldr r3, [r13, #0] //put s in r3
mov r2, r1 //p = ia
add r4, r1, r3 //r4 = ia+s
cmp r2, r4
bge endloop3
.label loop3
ldr r5, [r2] //*p
cmp r5, r0 //*p < sm
bge skip2
mov r0, r5
.label skip2
add r2, r2, #4 //p++
cmp r2, r4
blt loop3
.label endloop3
ldr r14, [r13, #12] //restore r14
add r13, r13, #16 //restore r13 stack
mov r15, r14       // return

.text 0x800
// r0 has an integer
// factorial must allocate a stack
// Save lr on stack and allocate space for local vars
.label factorial
cmp r0, #0 // if arg is 0, return n
beq factif1 // if true
mov r3, r0 // saves n into r3
sub r0, r0, #1 //decriments n and performs recursive call on n
sub r13, r13, #8 //space for n and lr
str r14, [r13, #4] // Saves lr into 1st space
str r3, [r13] //stores current n value into stack
blr factorial //recursion
ldr r3, [r13] //relaods previous n value
mul r0, r3, r0 // multiple returned value of factorial(n-1) by n
ldr r14, [r13, #4] // restores lr
add r13, r13, #8 // deallocates memory space after restoring desired values
mov r15, r14 //return
.label factif1 // if true
mov r0, #1 // sets r0 = 1
mov r15, r14 // return

            // Allocate stack
		    // implement algorithm
            //blr factorial    
            // factorial calls itself
            // Deallocate stack
            // return

.text 0x900
// This sample main implements the following
// int main() {
//     int n = 0, l = 0, c = 0;
//     printf("Something bad");
//     for (int i = 0; i < 3; i++)
//         printf("ia[%d]: %d", i, sia[i]);
//     n = numelems(sia);
//     sm1 = smallest(sia);
//     cav = cmp_arrays(sia, sib);
// }
.label main
sbi sp, sp, 40     // allocate space for stack
                   // [sp,0] is int cav
                   // [sp,4] is int n
                   // [sp,8] is int sm1
str lr, [sp, 16]   // [sp,12] is lr (save lr)
mov r0, 0
str r0, [sp, 0]    // cav = 0;
str r0, [sp, 4]    // n = 0;
str r0, [sp, 8]    // sm1 = 0;
str r0, [sp, 12]   // sm2 = 0
//sum of ia is 12
mov r2, #2
str r2, [sp, 20] //ia[0] = 2;
mov r2, #3
str r2, [sp, 24] //ia[1] = 3;
mov r2, #5
str r2, [sp, 28] //ia[2] = 5;
mov r2, #1
str r2, [sp, 32] //ia[3] = 1;
mov r2, #0
str r2, [sp, 36] //ia[4] = 0;

// cav = cmp_arrays(sia, sib);
mva r0, sia        // put address of sia in r0
mva r1, sib        // put address of sib in r1
blr cmp_arrays     // branch to cmp_arrays function
str r0, [sp, 0]    // cav = result from cmp_arrays
mva r0, fmt1
ldr r1, [sp, 0]
blr printf

// cav = cmp_arrays(sia, sia);
mva r0, sia        // addy of sia into r0
mva r1, sia        // addy of sia into r1 
blr cmp_arrays // branch to cmp_arrays
str r0, [sp, 0]
ldr r1, [sp, 0]
mva r0, fmt2
blr printf

// sib[0] = 4;
mva r4, sia // moves sia addy into r4
mov r5, #4
str r5, [r4, #0] // changes r4[0] to = 4
str r4, sia  // updates sia label with new r4

// cav = cmp_arrays(sib, sia);
mva r0, sib        // put address of sib in r0
mva r1, sia        // put address of sia in r1
blr cmp_arrays     // branch to cmp_arrays function
str r0, [sp, 0]    // cav = result from cmp_arrays
mva r0, fmt3
ldr r1, [sp, 0]
blr printf

// cav = cmp_arrays(ia, sib)
mov r0, sp        // put start of sp in r0
add r0, r0, #20    //r0 = start address of ia
mva r1, sib        // put address of sib in r1
blr cmp_arrays     // branch to cmp_arrays function
str r0, [sp, 0]    // cav = result from cmp_arrays
mva r0, fmt4
ldr r1, [sp, 0]
blr printf

//sort(ia)
//mov r0, sp  // put start of sp in r0
//add r0, r0, #20 //r0 = start address of ia
//blr sort  // branch to sort function, no return

// n = numelems(ia)
mov r0, sp  // put start of sp in r0
add r0, r0, #20 //r0 = start address of ia
blr numelems  // branch to numelems
str r0, [sp, 4]  // set result = n

// for (int i = 0: i < n; i++) {
//      printf("ia[%d]: %d\n", i, ia[i])   
mva r4, sp //put start of sp in r4
add r4, r4, #20 //r4 = start address of ia
ldr r5, #0 // r5 = i
.label printloop1
ldr r3, [sp, 4]
cmp r5, r3 // compares i to n
bge printendloop1  // if i >= n, branches to end of loop
str r6, [r4, r5] // takes the ia[i] value and stores it in r6
mva r0, fmt7  // sets r0 as format
mva r1, r5  // sets i as first arg
mva r2, r6  // sets ia[i] as second arg
blr printf
add r5, r5, #1 // increments r5 by 1
blt printloop1  //branches back to loop start
.label printendloop1

// sort(sia)
//mva r0, sia // sia addy into r0
//blr sort // branch to void sort function

// n = numelems(sia)
mva r0, sia  // sia addy into r0
blr numelems  // branch to numelems
str r0, [sp, 4]  // sets output to n (sp , 4)

// for (int i = 0: i < n; i++) {
//      printf("sia[%d]: %d\n", i, ia[i])
mva r4, sia //sets addy of ia into r4
ldr r5, #0 // r5 = i
.label printloop2
ldr r3, [sp, 4] 
cmp r5, r3 // compares i to n
bge printendloop2  // if i >= n, branches to end of loop
str r6, [r4, r5] // takes the ia[i] value and stores it in r6
mva r0, fmt8  // sets r0 as format
mva r1, r5  // sets i as first arg
mva r2, r6  // sets ia[i] as second arg
blr printf
add r5, r5, #1 // increments r5 by 1
blt printloop2  //branches back to loop start
.label printendloop2

// sm1 = smallest(ia)
// sm1 = [sp, 8]
mov r0, sp  // put r0 at start of sp
add r0, r0, #20 //r0 = start of ia
blr smallest
str r0, [sp, 8]

// sm2 = smallest(sia)
// sm2 = [sp, 12]
mva r0, sia
blr smallest
str r0, [sp, 12]

// printf("smallest(ia): %d\n", sm1);
mva r0, fmt9
ldr r1, [sp, 8]
blr printf

// printf("smallest(sia): %d\n", sm2);
mva r0, fmt10
ldr r1, [sp, 12]
blr printf

// if (sm1 != ia[0])
//    printf("Something bad\n");
// else
//    printf("Nice sort and smallest\n");
mov r0, sp //put r0 at start of sp
add r0, r0, #20 //r0 = start of ia
ldr r1, [sp, 8]
ldr r2, [r0]
cmp r1, r2  //sm1 compare to ia[0]
bne badprint1
mva r0, fmt6
blr printf
bal badskip1
.label badprint1
mva r0, fmt5
blr printf
.label badskip1

// if (sm2 != sia[0])
//  printf("Something bad\n");
// else
//  printf("Nice sort and smallest\n");
mva r0, sia
ldr r1, [sp, 8]
ldr r2, [r0]
cmp r1, r2 //sm2 compare to sia[0]
bne badprint2
mva r0, fmt6
blr printf
bal badskip2
.label badprint2
mva r0, fmt5
blr printf
.label badskip2

// n = factorial(4)
// [sp, 4] = n
mov r0, #4
blr factorial
str r0, [sp, 4]

// printf("factorial(4) is: %d\n", n);
mov r0, fmt11
ldr r1, [sp, 4]
blr printf

// n = factorial(7)
// [sp, 4] = n
mov r0, #7
blr factorial
str r0, [sp, 4]

// printf("factorial(7) is: %d\n", n);
mva r0, fmt12
ldr r1, [sp, 4]
blr printf
.label end
bal end

