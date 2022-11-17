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
.string //sia[%d]: %d
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
mov r3, [r13, #12] //s2
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
                   // Allocate stack
// blr numelems    // count elements in ia[]
                   // create nested loops to sort
		   // Deallocate stack
mov r15, r14       // return - sort is a void function

.text 0x700
// r0 has ia - address of null terminated array
// smallest must allocate a stack
// Save lr on stack and allocate space for local vars
.label smallest
                   // Allocate stack
// blr numelems    // count elements in ia[]
                   // create loop to find smallest
mov r0, 2          // hardcode to return a 2
		   // Deallocate stack
mov r15, r14       // return

.text 0x800
// r0 has an integer
// factorial must allocate a stack
// Save lr on stack and allocate space for local vars
.label factorial
sub r13, r13, #8 //space for n and lr
str r14, [r13, #4] //save lr on stack
str r0, [r13, #0] //n on stack
ldr r0, [r13, #0] //put n in r0
cmp r0, #1
beq if1
.label if1

                   // Allocate stack
		   // implement algorithm
//blr factorial    // factorial calls itself
		   // Deallocate stack
mov r15, r14       // return

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
sbi sp, sp, 16     // allocate space for stack
                   // [sp,0] is int cav
                   // [sp,4] is int n
                   // [sp,8] is int sm1
str lr, [sp, 12]   // [sp,12] is lr (save lr)
mov r0, 0
str r0, [sp, 0]    // cav = 0;
str r0, [sp, 4]    // n = 0;
str r0, [sp, 8]    // sm1 = 0;
// printf("Something bad");
// Kernel call to printf expects parameters
// r1 - address of format string - "Something bad"
// mva r1, bad
// ker #0x11
// The os has code for printf at address 0x7000
// The code there generates the ker instruction
// You call printf with
// r0 - has address of format string - "Something bad"
mva r0, fmt2
blr printf
//
// for (int i = 0; i < 4; i++)
//     printf("ia[%d]: %d", i, sia[i]);
mov r4, 0          // i to r4
mva r5, sia   // address is sia to r5
.label loop4times  // print 3 elements if sia
cmp r4, 4
bge end_loop4times
// Kernel call to printf expects parameters
// r1 - address of format string - "ia[%d]: %d"
// r2 - value for first %d
// r3 - value for second %d
mva r1, fmt1       // fmt1 to r1
mov r2, r4         // i to r2
ldr r3, [r5], 4    // sia[i] to r3
ker #0x11          // Kernel call to printf
adi r4, r4, 1      // i++
bal loop4times
.label end_loop4times
// int n = numelems(sia);
mva r0, sia        // put address of sia in r0
blr numelems       // n = numelems(sia)
str r0, [sp, 4]
// int sm1 = smallest(sia);
mva r0, sia        // put address of sia in r0
blr smallest       // sm1 = smallest(sia)
str r0, [sp, 8]    // store return value in sm1
// cav = cmp_arrays_sia, sib);
mva r0, sia        // put address of sia in r0
mva r1, sib        // put address of sib in r1
blr cmp_arrays
str r0, [sp, 0]
// Do not deallocate stack.
// This leaves r13 with an address that can be used to dump memory
// > d 0x4ff0 
// Shows the three hardcoded values stored in cav, n, and sm1.
// 0x4ff0 (0d20464) 0xffffffff 0x0000000a 0x00000002
.label end
bal end            // branch to self
