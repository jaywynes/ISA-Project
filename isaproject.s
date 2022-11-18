// The code you must implement is provided in ISAproject.pdf

// Define stack start address
.stack 0x5000

// Define address of printf
.text 0x7000
.label printf

.data 0x100
.label sia
50
43
100
-5
-10
50
0
.label sib
500
43
100
-5
-10
50
0
.label fmt1
.string //comparison: %d
.label fmt2
.string //Something bad
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
.label cmp_neq
cmp r0, r1  
bgt cmp_gt   //perform s1 < s2 ? if s1 != s2
ble cmp_le
.label cmp_gt
mov r0, #1  //if s1 > s2, r0 return is 1
.label cmp_le
mov r0, #-1 //if s1 <= s2, r0 return is -1
ldr r14, [r13, #16] //restore r14
add r13, r13, #20 //restore r13
mov r15, r14       // return

.text 0x500
// r0 has ia - address of null terminated array
// numelems is a leaf function
// If you only use r0, r1, r2, r3; you do not need a stack
.label numelems
mov r1, #0 // c = 0
ldr r2, [r0] // *ia in r2
cmp r2, #0 // check if *ia != 0
beq endnumelemswhile
.label numelemswhile1
add r1, r1, #1 //c++
add r0, r0, #4 // increments *ia
ldr r2, [r0] // puts next *ia value into r2
cmp r2, #0
bne numelemswhile1
.label endnumelemswhile
mov r0, r1 // sets r0 = c to return
mov r15, r14       // return

.text 0x600
// r0 has ia - address of null terminated array
// sort must allocate a stack
// Save lr on stack and allocate space for local vars
.label sort
sub r13, r13, #20 //space for s, i, j, t, lr
mov r1, r0 //move address of ia to r1
blr numelems
str r0, [r13, #0] //s = numelems(ia);
mov r0, #0
str r0, [r13, #4] //i = 0
str r0, [r13, #8] //j = 0
str r0, [r13, #12] //t = 0
str r14, [r13, #16] //save lr on stack
mov r0, r1 //move address of ia back to r0
ldr r1, [r13, #0] //put s in r1
ldr r2, [r13, #4] //put i in r2
cmp r2, r1
bge endloop1
.label loop1
ldr r3, [r13, #8] //put j in r3
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
ldr r8, [r13, #12] //put t in r8
mov r8, r5
mov r5, r7
mov r7, r8
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
ldr r14, [r13, #16] //restore lr
add r13, r13, #20 //restore r13 stack
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
sub r13, r13, #20 // allocates space for *ia
mov r2, #2 
str r2, [r13, #0] //ia[0] = 2
mov r2, #3
str r2, [r13, #4] //ia[0] = 2
mov r2, #5
str r2, [r13, #8] //ia[0] = 2
mov r2, #1
str r2, [r13, #12] //ia[0] = 2
mov r2, #0
str r2, [r13, #16] //ia[0] = 2

sbi sp, sp, 16     // allocate space for stack
                   // [sp,0] is int cav
                   // [sp,4] is int n
                   // [sp,8] is int sm1
str lr, [sp, 12]   // [sp,12] is lr (save lr)
mov r0, 0
str r0, [sp, 0]    // cav = 0;
str r0, [sp, 4]    // n = 0;
str r0, [sp, 8]    // sm1 = 0;

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
mva r0, fmt1
blr printf

// sib[0] = 4;
mva r4, sia // moves sia addy into r4
mov r5, #4
str r5, [r4, #0] // changes r4[0] to = 4
str r4, sia  // updates sia label with new r4

// cav = cmp_arrays(sia, sib);
mva r0, sia        // put address of sia in r0
mva r1, sib        // put address of sib in r1
blr cmp_arrays     // branch to cmp_arrays function
str r0, [sp, 0]    // cav = result from cmp_arrays
mva r0, fmt1
ldr r1, [sp, 0]
blr printf

// cav = cmp_arrays(ia, sib)
mva r0, r13        // put address of ia in r0
mva r1, sib        // put address of sib in r1
blr cmp_arrays     // branch to cmp_arrays function
str r0, [sp, 0]    // cav = result from cmp_arrays
mva r0, fmt1
ldr r1, [sp, 0]
blr printf

// sort(ia)

.label end
bal end

