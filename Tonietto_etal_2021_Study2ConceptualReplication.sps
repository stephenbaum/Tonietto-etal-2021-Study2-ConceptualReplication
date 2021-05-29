* Encoding: UTF-8.

*/ Load in the dataset.
*/ Change the condition variable to numeric.

*/ Compute a variable for people that pass AC and have not done a similar study.
COMPUTE use = 0.
IF (AC = 1 & similar = 2) use = 1.
EXECUTE.

*/ Exclude participants that failed AC or done similar study before.
USE ALL.
COMPUTE filter_$=(use = 1).
VARIABLE LABELS filter_$ 'use = 1 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

*/ Look at all of the within-condition simple effects.
T-TEST PAIRS=orig_start_1 orig_start_clar_1 orig_start_samepg_1 WITH orig_end_1 orig_end_clar_1 
    orig_end_samepg_1 (PAIRED)
  /ES DISPLAY(TRUE) STANDARDIZER(SD)
  /CRITERIA=CI(.9500)
  /MISSING=ANALYSIS.

*/ Ok, let's compute a new variable that identifies whether or not people are directionally correct in their estimates.
COMPUTE dir_cor = 0.
IF (orig_start_1 < orig_end_1) dir_cor =1.
IF (orig_start_clar_1 < orig_end_clar_1) dir_cor = 1.
IF (orig_start_samepg_1 < orig_end_samepg_1) dir_cor = 1.
EXECUTE.

*/ And let's look at that new variable by condition to see if people are directionally incorrect more in one condition than others.
SORT CASES  BY condition.
SPLIT FILE SEPARATE BY condition.

*/ And now actually look at the frequencies.
FREQUENCIES VARIABLES=dir_cor
  /ORDER=ANALYSIS.
