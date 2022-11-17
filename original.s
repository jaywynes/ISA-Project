//void sort(int *ia, int s) {
//    for (int i = 0; i < s; i++)
//        for (int j = i+1; j < s; j++)
//            if (ia[i] > ia[j]) {
//                int t = ia[j];
//                ia[j] = ia[i];
//                ia[i] = t;
//            }
//}
//
//int count(int *ia, int s, int v) {
//    int c = 0;
//    for (int i = 0; i < s; i++)
//        if (ia[i] == v)
//            c++;
//    return c;
//}
//        
//int largest(int *ia, int s) {
//    int l = *ia;
//    for (int *p = ia; p < ia+s; p++)
//        if (*p > l)
//            l = *p;
//    return l;
//}
//
//int numelems(int *ia) {
//    int c = 0;
//    while (*ia++ != 0)
//        c++;
//    return c;
//}
//
//static int staticia[] = {50,43,100,-5,-10,50,0};
//int main() {
//    int ia[] = {2,3,5,1,0};
//    sort(ia, numelems(ia));
//    for (int i = 0; i < numelems(ia); i++)
//        printf("ia[%d]: %d\n", i, ia[i]);
//    sort(staticia, numelems(staticia));
//    for (int i = 0; i < numelems(staticia); i++)
//        printf("ia[%d]: %d\n", i, staticia[i]);
//    printf("ia:       count of %d is %d\n", 50, count(ia, numelems(ia), 50));
//    printf("staticia: count of %d is %d\n", 50, count(staticia, numelems(staticia), 50));
//    printf("largest: %d\n", largest(ia, numelems(ia)));
//    printf("largest: %d\n", largest(staticia, numelems(staticia)));
//    if (largest(ia, numelems(ia)) != ia[numelems(ia)-1])
//        printf("Something bad\n");
//    else
//        printf("Nice sort and largest\n");
//    if (largest(staticia, numelems(staticia)) != staticia[numelems(staticia)-1])
//        printf("Something bad\n");
//    else
//        printf("Nice sort and largest\n");
//}
.stack 0x5000
.data 0x100
.label printf1
.string //ia[%d]: %d\n
.label printf2
.string //ia:       count of %d is %d\n
.label printf3
.string //staticia: count of %d is %d\n
.label printf4
.string //largest: %d\n
.label printfbad
.string //Something bad\n
.label printfgood
.string //Nice sort and largest\n

.label staticia
50
43
100
-5
-10
50
0

.text 0x700
.label code
.label main
sub r13, r13, #28 //space for ia[], i and r14
mov r2, #2
str r2, [r13, #0] // ia[0] = 2
mov r2, #3
str r2, [r13, #4]   // ia[1] = 3
mov r2, #5
str r2, [r13, #8]   // ia[2] = 5
mov r2, #1
str r2, [r13, #12]  // ia[3] = 1
mov r2, #0
str r2, [r13, #16]  // ia[4] = 0
str r14, [r13, #24] //save lr on stack
mov r0, r13 //mov address of array into r0 from stack
blr numelems
blr sort
mov r4, r1 //numelems in r4
mov r3, #0
str r3, [r13, #20] //i = 0;
cmp r3, r4
bge skip2
.label forloop1
mva r0, printf1 //r0 has fmt string
mov r1, r3      //r1 has i
mov r2, [r0, r3] //r2 has ia[i]
ker #0x11
add r3, r3, #1 //i++
cmp r3, r4 //i < numelems
blt forloop1
.label skip2
mva r0, staticia //r0 has staticia[]
blr numelems
blr sort
mov r4, r1 //numelems in r4
mov r3, #0
str r3, [r13, #20] //i = 0;



//r1 has numelems
.label numelems
sub r13, r13, #4 //space for lr
str r14, [r13, #0] //save lr on stack
mov r1, #0      //int c = 0;
mov r3, r0 //move address of ia into r3
.label while
ldr r4, [r3], #4 //put ia[index] into r4
cmp r4, #0
beq endwhile
add r1, r1, #1 //c++
bal while
.label endwhile
ldr r14, [r13, #0] //restore lr
add r13, r13, #4   //restore r13
mov r15, r14       // return to call

//r1 has numelems
.label sort
sub r13, r13, #12  //space for i, j, and lr
str r14, [r13, #8] //save lr on stack
mov r3, r0  //mov address of ia to r3
mov r5, #0
str r5, [r13, #0] //i = 0;
cmp r5, r1
bge endloop1
.label loop
ldr r7, [r3, r5] //put ia[i] into r6
add r6, r5, #1
str r6, [r13, #4] //j = 1;
cmp r6, r1
bge endloop2
.label loop2
ldr r8, [r3, r6] //put ia[j] into r7
cmp r7, r8
blt skip
mov r9, r8  //int t = ia[j]
mov r8, r7  // ia[j] = ia[i]
mov r7, r9 // ia[i] = t
str r7, [r3, r5] //store new ia[i] into ia[i] using i
str r8, [r3, r6] //store new ia[j] into ia[j] using j
.label skip
add r6, r6, #1 //j++
cmp r6, r1
blt loop2
.label endloop2
add r5, r5, #1 //i++
cmp r5, r1
blt loop
.label endloop1
ldr r14, [r13, #8] //restore lr
add r13, r13, #12 //restore r13
mov r15, r14

