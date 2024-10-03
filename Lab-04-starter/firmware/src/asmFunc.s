/*** asmFunc.s   ***/
/* Tell the assembler to allow both 16b and 32b extended Thumb instructions */
.syntax unified

#include <xc.h>

/* Tell the assembler that what follows is in data memory    */
.data
.align
 
/* define and initialize global variables that C can access */

.global balance,transaction,eat_out,stay_in,eat_ice_cream,we_have_a_problem
.type balance,%gnu_unique_object
.type transaction,%gnu_unique_object
.type eat_out,%gnu_unique_object
.type stay_in,%gnu_unique_object
.type eat_ice_cream,%gnu_unique_object
.type we_have_a_problem,%gnu_unique_object

/* NOTE! These are only initialized ONCE, right before the program runs.
 * If you want these to be 0 every time asmFunc gets called, you must set
 * them to 0 at the start of your code!
 */
balance:           .word     0  /* input/output value */
transaction:       .word     0  /* output value */
eat_out:           .word     0  /* output value */
stay_in:           .word     0  /* output value */
eat_ice_cream:     .word     0  /* output value */
we_have_a_problem: .word     0  /* output value */

 /* Tell the assembler that what follows is in instruction memory    */
.text
.align

/* Tell the assembler to allow both 16b and 32b extended Thumb instructions */
.syntax unified

    
/********************************************************************
function name: asmFunc
function description:
     output = asmFunc ()
     
where:
     output: the integer value returned to the C function
     
     function description: The C call ..........
     
     notes:
        None
          
********************************************************************/    
.global asmFunc
.type asmFunc,%function
asmFunc:   

    /* save the caller's registers, as required by the ARM calling convention */
    push {r4-r11,LR}
 
.if 0
    /* profs test code. */
    LDR r1,=balance
    LDR r2,[r1]
    ADD r0,r0,r2
.endif
    
    /*** STUDENTS: Place your code BELOW this line!!! **************/
    MOV	    r2, 0   /* load 0 in r2 to reset output variables to 0*/
    
    /* Set output variables to 0. */
    LDR	    r1, =eat_out    /* load mem address of "eat_out" into r1*/
    STR	    r2, [r1]	    /* store 0 to mem location pointed to by "eat_out" */
    
    LDR	    r1, =stay_in    /* load mem address of "stay_in" into r1*/
    STR	    r2, [r1]	    /* store 0 to mem location pointed to by "stay_in". */
    
    LDR	    r1, =eat_ice_cream	/* load mem address of "eat_ice_cream" into r1*/
    STR	    r2, [r1]		/* store 0 to mem location pointed to by "eat_ice_cream". */
    
    LDR	    r1, = we_have_a_problem /* load mem address of "we_have_a_problem" into r1*/
    STR	    r2, [r1]		    /* store 0 to mem location pointed to by "we_have_a_problem". */
    
    /* Copy "transaction_amount" from r0 to mem location "transaction". */	    
    LDR	    r1, =transaction	/* load mem address of "transaction" into r1*/
    STR	    r0, [r1]		/* store the transaction amount into mem location pointed to by
				 * "transaction". */
    
    /* Check if the transaction amount is within -1000 to 1000, inclusive.*/
    MOV	    r3, 1000	/* Load upper limit (1000) in r3. */
    CMP	    r0, r3	/* Compare transaction amount in r0 with 1000.*/
    BGT over_1000	/* If transaction amount > 1000, branch to "over_1000". */
    
    MOV	    r3, 1000	/* Load lower limit in r3. */
    RSB	    r3, r3, 0	/* Reverse subtract 1000 from 0 (resulting in -1000).*/
    CMP	    r0, r3	/* Compare transaction amount in r0 with -1000.*/
    BLT under_Neg_1000	/* If transaction amount < -1000, branch to 
			* "under_NEG_1000". */
    
    /*  calculate tmpBalance = balance + transaction amount*/
    LDR	    r1, = balance   /* load mem adress of "balance" into r1. */
    LDR	    r2, [r1]	    /* load balance into r2. */
    ADDS    r3, r2, r0	    /* Add transaction amount to the balance and store
			    * the tmpBalance in r3. Update flags. */
    BVS over_Flow	    /* If overflow, branch to "over_Flow". */
     
     /* If there is no overflow, update values stored at mem locations
     *	balance and transaction with the values as described in the flow chart.*/
    STR	    r3, [r1]	/* Store tmpBalance in r3 in mem location pointed to by balance. */
    CMP	    r3, 0	/* Compare tmpBalance with 0. */
    BGT eat_Out		/* If balance > 0, branch to "eat_Out". */
    BLT stay_In		/* If balance < 0, branch to "stay_In". */
    BEQ eat_Ice_Cream	/* If balance == 0, branch to "eat_Ice_Cream". */
    
    eat_Out: /* If balance > 0 then set "eat_out" to 1.*/
    LDR	    r1, =eat_out    /* load the mem address of "eat_out" into r1*/
    MOV	    r2, 1	    /* load literal 1 into r2.*/
    STR	    r2, [r1]	    /* Store 1 in mem location pointed to by "eat_out". */
    B update_Register_0	    /* Branch to "update_Register_0". */
    
    stay_In: /* If balance > 0 then set "stay_in" to 1.*/
    LDR	    r1, = stay_in   /* load mem adress of "stay_in" into r1*/
    MOV	    r2, 1	    /* load literal 1 into r2.*/
    STR	    r2, [r1]	    /* Store 1 in mem location pointed to by "stay_in". */
    B update_Register_0	    /* Branch to "update_Register_0". */
    
    eat_Ice_Cream: /* If balance == 0 than set "eat_ice_cream to 1." */
    LDR	    r1, = eat_ice_cream	/* load mem address of "eat_ice_cream" into r1*/
    MOV	    r2, 1		/* load literal 1 into r2.*/
    STR	    r2, [r1]		/* Store 1 in mem location pointed to by "eat_ice_cream". */
    B update_Register_0		/* Branch to "update_Register_0". */
    
    over_1000: /* If transaction amount greater than upper limit. */
    LDR	    r1, =transaction	/* Load mem address of "transaction" into r1.*/
    MOV	    r2, 0		/* Load literal 0 into r2.*/
    STR	    r2, [r1]		/* Store 0 in mem location pointed to by "transaction".*/
    
    LDR	    r1, =we_have_a_problem  /* Load mem address of "we_have_a_problem" into r1.*/
    MOV	    r2, 1		    /* Load literal 1 into r2.*/
    STR	    r2, [r1]		    /* Store 1 in mem location pointed to by "we_have_a_problem".*/
    B update_Register_0		    /* Branch to "update_Register_0". */

    under_Neg_1000: /* If transaction amount less than lower limit. */
    LDR	    r1, =transaction	/* Load mem address of "transaction" into r1.*/
    MOV	    r2, 0		/* Load literal 0 into r2.*/
    STR	    r2, [r1]		/* Store 1 in mem location pointed to by "transaction".*/
    
    LDR	    r1, =we_have_a_problem  /* Load mem address of "we_have_a_problem" into r1.*/
    MOV	    r2, 1		    /* Load literal 1 into r2.*/
    STR	    r2, [r1]		    /* Store 1 in mem location pointed to by "we_have_a_problem".*/
    B update_Register_0		    /* Branch to "update_Register_0". */
    
    over_Flow: /* If overflow occurs. */
    LDR r1, =transaction    /* Load mem address of "transaction" into r1.*/
    MOV r2, 0		    /* Load literal 0 into r2.*/
    STR r2, [r1]	    /* Store 1 in mem location pointed to by "transaction".*/
    
    LDR	    r1, =we_have_a_problem  /* Load mem address of "we_have_a_problem" into r1.*/
    MOV	    r2, 1		    /* Load literal 1 into r2.*/
    STR	    r2, [r1]		    /* Store 1 in mem location pointed to by "we_have_a_problem".*/
    B update_Register_0		    /* Branch to "update_Register_0". */
    
    update_Register_0: /* Update r0 with new balance and branch to "done".*/
    LDR	    r1, =balance    /* Load the mem adress of balance into r1. */
    LDR	    r0, [r1]	    /* Load the value of balance into r0. */
    B done		    /* Branch to "done".*/
    
    done:
    
    /*** STUDENTS: Place your code ABOVE this line!!! **************/

done:    
    /* restore the caller's registers, as required by the 
     * ARM calling convention 
     */
    pop {r4-r11,LR}

    mov pc, lr	 /* asmFunc return to caller */
   

/**********************************************************************/   
.end  /* The assembler will not process anything after this directive!!! */
           




