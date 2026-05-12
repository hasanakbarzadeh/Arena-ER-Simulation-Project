
;
;
;     Model statements for module:  DiscreteProcessing.Create 1 (WalkIns)
;

49$           CREATE,        1,MinutesToBaseTime(0.0),Patient:MinutesToBaseTime(WEIB(16.84,0.894)):NEXT(50$);

50$           ASSIGN:        WalkIns.NumberOut=WalkIns.NumberOut + 1:NEXT(27$);


;
;
;     Model statements for module:  InputOutput.ReadWrite 1 (ReadWrite Walk_Ins)
;
27$           READ,          HospitalizationTimeWalkIns:
                             Hospitalization_Time_hour:NEXT(0$);


;
;
;     Model statements for module:  DiscreteProcessing.Process 1 (Triage)
;
0$            ASSIGN:        Triage.NumberIn=Triage.NumberIn + 1:
                             Triage.WIP=Triage.WIP+1;
58$           QUEUE,         Triage.Queue;
57$           SEIZE,         2,VA:
                             Nurse,1:NEXT(56$);

56$           DELAY:         MinutesToBaseTime(Uniform(5,15)),,VA;
55$           RELEASE:       Nurse,1;
103$          ASSIGN:        Triage.NumberOut=Triage.NumberOut + 1:
                             Triage.WIP=Triage.WIP-1:NEXT(2$);


;
;
;     Model statements for module:  DiscreteProcessing.Assign 1 (Patient Type WalkIns)
;
2$            ASSIGN:        Patient_Proiority=DISC(0.0061, 1, 0.0433,2, 0.2435, 3 , 0.6905, 4, 1.0, 5):NEXT(3$);


;
;
;     Model statements for module:  Decisions.Decide 1 (Urgent Care Needed for patient?)
;
3$            BRANCH,        1:
                             If,Patient_Proiority==1,38$,Yes:
                             If,Patient_Proiority==2,39$,Yes:
                             If,Patient_Proiority==3,40$,Yes:
                             If,Patient_Proiority==4,41$,Yes:
                             Else,42$,Yes;

;
;
;     Model statements for module:  DiscreteProcessing.Assign 12 (P5 Patient Assignment)
;
42$           ASSIGN:        Entity.Type=P5_Patient:NEXT(4$);


;
;
;     Model statements for module:  DiscreteProcessing.Process 4 (WaitingRoom)
;
4$            ASSIGN:        WaitingRoom.NumberIn=WaitingRoom.NumberIn + 1:
                             WaitingRoom.WIP=WaitingRoom.WIP+1;
111$          QUEUE,         WaitingRoom.Queue;
110$          SEIZE,         2,VA:
                             Chair,1:NEXT(109$);

109$          DELAY:         HoursToBaseTime(Triangular(.5,1,1.5)),,VA;
156$          ASSIGN:        WaitingRoom.NumberOut=WaitingRoom.NumberOut + 1:
                             WaitingRoom.WIP=WaitingRoom.WIP-1:NEXT(19$);


;
;
;     Model statements for module:  DiscreteProcessing.Seize 1 (Seizing Exam Room)
;
19$           QUEUE,         Seizing Exam Room.Queue;
              SEIZE,         2,Other:
                             Exam Room,1:NEXT(160$);

160$          DELAY:         0.0,,VA:NEXT(159$);

159$          DELAY:         0.0,,VA:NEXT(32$);


;
;
;     Model statements for module:  DiscreteProcessing.Release 11 (Release Chair)
;
32$           RELEASE:       Chair,1:NEXT(16$);


;
;
;     Model statements for module:  DiscreteProcessing.Process 8 (Examination)
;
16$           ASSIGN:        Examination.NumberIn=Examination.NumberIn + 1:
                             Examination.WIP=Examination.WIP+1;
164$          QUEUE,         Examination.Queue;
163$          SEIZE,         2,VA:
                             Doctor,1:NEXT(162$);

162$          DELAY:         MinutesToBaseTime(Triangular(10,15,20)),,VA;
161$          RELEASE:       Doctor,1;
209$          ASSIGN:        Examination.NumberOut=Examination.NumberOut + 1:
                             Examination.WIP=Examination.WIP-1:NEXT(17$);


;
;
;     Model statements for module:  Decisions.Decide 8 (Is Additional Blood Test Required?)
;
17$           BRANCH,        1:
                             With,(71.27)/100,212$,Yes:
                             Else,213$,Yes;
212$          ASSIGN:        Is Additional Blood Test Required?.NumberOut True=
                             Is Additional Blood Test Required?.NumberOut True + 1:NEXT(18$);

213$          ASSIGN:        Is Additional Blood Test Required?.NumberOut False=
                             Is Additional Blood Test Required?.NumberOut False + 1:NEXT(21$);


;
;
;     Model statements for module:  DiscreteProcessing.Process 9 (Blood Test)
;
18$           ASSIGN:        Blood Test.NumberIn=Blood Test.NumberIn + 1:
                             Blood Test.WIP=Blood Test.WIP+1;
217$          QUEUE,         Blood Test.Queue;
216$          SEIZE,         2,VA:
                             Nurse,1:NEXT(215$);

215$          DELAY:         HoursToBaseTime(Triangular(.5,1,1.5)),,VA;
214$          RELEASE:       Nurse,1;
262$          ASSIGN:        Blood Test.NumberOut=Blood Test.NumberOut + 1:
                             Blood Test.WIP=Blood Test.WIP-1:NEXT(22$);


;
;
;     Model statements for module:  DiscreteProcessing.Delay 7 (Waiting for the Blood test REsult)
;
22$           DELAY:         HoursToBaseTime(UNIF( 1 , 3 )),,Other:NEXT(23$);


;
;
;     Model statements for module:  Decisions.Decide 10 (Is X_ray Needed After Blood Test?)
;
23$           BRANCH,        1:
                             With,(8)/100,265$,Yes:
                             Else,266$,Yes;
265$          ASSIGN:        Is X_ray Needed After Blood Test?.NumberOut True=
                             Is X_ray Needed After Blood Test?.NumberOut True + 1:NEXT(24$);

266$          ASSIGN:        Is X_ray Needed After Blood Test?.NumberOut False=
                             Is X_ray Needed After Blood Test?.NumberOut False + 1:NEXT(43$);


;
;
;     Model statements for module:  DiscreteProcessing.Process 10 (X_ray)
;
24$           ASSIGN:        X_ray.NumberIn=X_ray.NumberIn + 1:
                             X_ray.WIP=X_ray.WIP+1;
270$          QUEUE,         X_ray.Queue;
269$          SEIZE,         2,VA:
                             X_rayMachine,1:NEXT(268$);

268$          DELAY:         MinutesToBaseTime(Normal(10,2)),,VA;
267$          RELEASE:       X_rayMachine,1;
315$          ASSIGN:        X_ray.NumberOut=X_ray.NumberOut + 1:
                             X_ray.WIP=X_ray.WIP-1:NEXT(43$);


;
;
;     Model statements for module:  DiscreteProcessing.Delay 13 (Doctor Waitning for Results)
;
43$           DELAY:         MinutesToBaseTime(UNIF(10,15)),,Other:NEXT(25$);


;
;
;     Model statements for module:  DiscreteProcessing.Process 11 (Doctor Diagnosis)
;
25$           ASSIGN:        Doctor Diagnosis.NumberIn=Doctor Diagnosis.NumberIn + 1:
                             Doctor Diagnosis.WIP=Doctor Diagnosis.WIP+1;
321$          QUEUE,         Doctor Diagnosis.Queue;
320$          SEIZE,         2,VA:
                             Doctor,1:NEXT(319$);

319$          DELAY:         MinutesToBaseTime(Normal(13,5)),,VA;
318$          RELEASE:       Doctor,1;
366$          ASSIGN:        Doctor Diagnosis.NumberOut=Doctor Diagnosis.NumberOut + 1:
                             Doctor Diagnosis.WIP=Doctor Diagnosis.WIP-1:NEXT(26$);


;
;
;     Model statements for module:  DiscreteProcessing.Release 5 (Release Exam Room)
;
26$           RELEASE:       Exam Room,1:NEXT(37$);


;
;
;     Model statements for module:  DiscreteProcessing.Dispose 9 (Non_Urgent Discharged Home)
;
37$           ASSIGN:        Non_Urgent Discharged Home.NumberOut=Non_Urgent Discharged Home.NumberOut + 1;
369$          DISPOSE:       Yes;


;
;
;     Model statements for module:  Decisions.Decide 9 (X_ray is Needed?)
;
21$           BRANCH,        1:
                             With,(21)/100,370$,Yes:
                             Else,371$,Yes;
370$          ASSIGN:        X_ray is Needed?.NumberOut True=X_ray is Needed?.NumberOut True + 1:NEXT(24$);

371$          ASSIGN:        X_ray is Needed?.NumberOut False=X_ray is Needed?.NumberOut False + 1:NEXT(43$);


;
;
;     Model statements for module:  DiscreteProcessing.Assign 8 (P1_Patient Assignment)
;
38$           ASSIGN:        Entity.Type=P1_Patient:NEXT(10$);


;
;
;     Model statements for module:  DiscreteProcessing.Process 7 (Stabiization Process)
;
10$           ASSIGN:        Stabiization Process.NumberIn=Stabiization Process.NumberIn + 1:
                             Stabiization Process.WIP=Stabiization Process.WIP+1;
375$          QUEUE,         Stabiization Process.Queue;
374$          SEIZE,         1,VA:
                             Doctor,1:
                             Bed,1:NEXT(373$);

373$          DELAY:         MinutesToBaseTime(Triangular(0,0,60)),,VA;
420$          ASSIGN:        Stabiization Process.NumberOut=Stabiization Process.NumberOut + 1:
                             Stabiization Process.WIP=Stabiization Process.WIP-1:NEXT(11$);


;
;
;     Model statements for module:  DiscreteProcessing.Release 1 (Doctor Is Released after Stabilization)
;
11$           RELEASE:       Doctor,1:NEXT(7$);


;
;
;     Model statements for module:  Decisions.Decide 5 (Transferred to Another Hospital)
;
7$            BRANCH,        1:
                             With,(5)/100,423$,Yes:
                             Else,424$,Yes;
423$          ASSIGN:        Transferred to Another Hospital.NumberOut True=Transferred to Another Hospital.NumberOut True + 1
                             :NEXT(12$);

424$          ASSIGN:        Transferred to Another Hospital.NumberOut False=Transferred to Another Hospital.NumberOut False + 1
                             :NEXT(13$);


;
;
;     Model statements for module:  DiscreteProcessing.Release 2 (Bed Release for 5%)
;
12$           RELEASE:       Bed,1:NEXT(8$);


;
;
;     Model statements for module:  DiscreteProcessing.Dispose 1 (Another Hospital)
;
8$            ASSIGN:        Another Hospital.NumberOut=Another Hospital.NumberOut + 1;
425$          DISPOSE:       Yes;


;
;
;     Model statements for module:  Grouping.Separate 1 (Separating to count for Deterioration)
;
13$           DUPLICATE,     100 - 0:
                             1,428$,0:NEXT(427$);

427$          ASSIGN:        Separating to count for Deterioration.NumberOut Orig=
                             Separating to count for Deterioration.NumberOut Orig + 1:NEXT(29$);

428$          ASSIGN:        Separating to count for Deterioration.NumberOut Dup=
                             Separating to count for Deterioration.NumberOut Dup + 1:NEXT(14$);


;
;
;     Model statements for module:  Decisions.Decide 12 (If Hospitalization Time is not less than 24 hours?)
;
29$           BRANCH,        1:
                             If,Hospitalization_Time_hour>=24,429$,Yes:
                             Else,430$,Yes;
429$          ASSIGN:        If Hospitalization Time is not less than 24 hours?.NumberOut True=
                             If Hospitalization Time is not less than 24 hours?.NumberOut True + 1:NEXT(44$);

430$          ASSIGN:        If Hospitalization Time is not less than 24 hours?.NumberOut False=
                             If Hospitalization Time is not less than 24 hours?.NumberOut False + 1:NEXT(45$);


;
;
;     Model statements for module:  DiscreteProcessing.Assign 13 (Assign Transfer Exit Time)
;
44$           ASSIGN:        a_ExitTime=TNOW + HoursToBaseTime(TRIA(0.5,1.5,4)):NEXT(46$);


;
;
;     Model statements for module:  DiscreteProcessing.Process 15 (Nursing Care)
;
46$           ASSIGN:        Nursing Care.NumberIn=Nursing Care.NumberIn + 1:
                             Nursing Care.WIP=Nursing Care.WIP+1;
434$          QUEUE,         Nursing Care.Queue;
433$          SEIZE,         2,VA:
                             Nurse,1:NEXT(432$);

432$          DELAY:         MinutesToBaseTime(Uniform(5,15)),,VA;
431$          RELEASE:       Nurse,1;
479$          ASSIGN:        Nursing Care.NumberOut=Nursing Care.NumberOut + 1:
                             Nursing Care.WIP=Nursing Care.WIP-1:NEXT(47$);


;
;
;     Model statements for module:  Decisions.Decide 17 (Is Time Up?)
;
47$           BRANCH,        1:
                             If,a_ExitTime<=TNOW,482$,Yes:
                             Else,483$,Yes;
482$          ASSIGN:        Is Time Up?.NumberOut True=Is Time Up?.NumberOut True + 1:NEXT(30$);

483$          ASSIGN:        Is Time Up?.NumberOut False=Is Time Up?.NumberOut False + 1:NEXT(48$);


;
;
;     Model statements for module:  DiscreteProcessing.Release 7 (Bed Release until)
;
30$           RELEASE:       Bed,1:NEXT(31$);


;
;
;     Model statements for module:  DiscreteProcessing.Dispose 6 (Urgent Care go Home)
;
31$           ASSIGN:        Urgent Care go Home.NumberOut=Urgent Care go Home.NumberOut + 1;
484$          DISPOSE:       Yes;


;
;
;     Model statements for module:  DiscreteProcessing.Delay 14 (Care Time)
;
48$           DELAY:         0.041666666666667,,Other:NEXT(46$);


;
;
;     Model statements for module:  DiscreteProcessing.Assign 14 (Assign ER Stay Exit Time)
;
45$           ASSIGN:        a_ExitTime=TNOW + HoursToBaseTime(Hospitalization_Time_hour):NEXT(46$);


;
;
;     Model statements for module:  DiscreteProcessing.Delay 6 (Clone Waiting if Deterioration happen)
;
14$           DELAY:         0.041666666666667,,Other:NEXT(15$);


;
;
;     Model statements for module:  Decisions.Decide 6 (the Situation gets Detiriorated?)
;
15$           BRANCH,        1:
                             With,(20)/100,485$,Yes:
                             Else,486$,Yes;
485$          ASSIGN:        the Situation gets Detiriorated?.NumberOut True=the Situation gets Detiriorated?.NumberOut True + 1
                             :NEXT(33$);

486$          ASSIGN:        the Situation gets Detiriorated?.NumberOut False=
                             the Situation gets Detiriorated?.NumberOut False + 1:NEXT(34$);


;
;
;     Model statements for module:  DiscreteProcessing.Process 14 (Deterioration Stabilization)
;
33$           ASSIGN:        Deterioration Stabilization.NumberIn=Deterioration Stabilization.NumberIn + 1:
                             Deterioration Stabilization.WIP=Deterioration Stabilization.WIP+1;
490$          QUEUE,         Deterioration Stabilization.Queue;
489$          SEIZE,         2,VA:
                             Doctor,1:NEXT(488$);

488$          DELAY:         MinutesToBaseTime(Triangular(0,0,60)),,VA;
487$          RELEASE:       Doctor,1;
535$          ASSIGN:        Deterioration Stabilization.NumberOut=Deterioration Stabilization.NumberOut + 1:
                             Deterioration Stabilization.WIP=Deterioration Stabilization.WIP-1:NEXT(14$);


;
;
;     Model statements for module:  Decisions.Decide 16 (Not Need Nursing Care again P1?)
;
34$           BRANCH,        1:
                             If,a_ExitTime<=TNOW,538$,Yes:
                             Else,539$,Yes;
538$          ASSIGN:        Not Need Nursing Care again P1?.NumberOut True=Not Need Nursing Care again P1?.NumberOut True + 1
                             :NEXT(35$);

539$          ASSIGN:        Not Need Nursing Care again P1?.NumberOut False=Not Need Nursing Care again P1?.NumberOut False + 1
                             :NEXT(14$);


;
;
;     Model statements for module:  DiscreteProcessing.Dispose 8 (Clone Remove P1)
;
35$           ASSIGN:        Clone Remove P1.NumberOut=Clone Remove P1.NumberOut + 1;
540$          DISPOSE:       Yes;


;
;
;     Model statements for module:  DiscreteProcessing.Assign 9 (P2_Patient Assginement)
;
39$           ASSIGN:        Entity.Type=P2_Patient:NEXT(9$);


;
;
;     Model statements for module:  DiscreteProcessing.Process 6 (P2 Treatment)
;
9$            ASSIGN:        P2 Treatment.NumberIn=P2 Treatment.NumberIn + 1:
                             P2 Treatment.WIP=P2 Treatment.WIP+1;
544$          QUEUE,         P2 Treatment.Queue;
543$          SEIZE,         2,VA:
                             Bed,1:
                             Doctor,1:NEXT(542$);

542$          DELAY:         MinutesToBaseTime(Normal(30,10)),,VA;
589$          ASSIGN:        P2 Treatment.NumberOut=P2 Treatment.NumberOut + 1:
                             P2 Treatment.WIP=P2 Treatment.WIP-1:NEXT(36$);


;
;
;     Model statements for module:  DiscreteProcessing.Release 12 (Release Only Doctor)
;
36$           RELEASE:       Doctor,1:NEXT(29$);


;
;
;     Model statements for module:  DiscreteProcessing.Assign 10 (P3 Patient Assignment)
;
40$           ASSIGN:        Entity.Type=P3_Patient:NEXT(4$);


;
;
;     Model statements for module:  DiscreteProcessing.Assign 11 (P4 Patient Assignment)
;
41$           ASSIGN:        Entity.Type=P4_Patient:NEXT(4$);


;
;
;     Model statements for module:  DiscreteProcessing.Create 2 (Ambulance)
;

592$          CREATE,        1,MinutesToBaseTime(0.0),Patient:MinutesToBaseTime(WEIB(145.48,0.912)):NEXT(593$);

593$          ASSIGN:        Ambulance.NumberOut=Ambulance.NumberOut + 1:NEXT(28$);


;
;
;     Model statements for module:  InputOutput.ReadWrite 2 (ReadWrite Ambulance)
;
28$           READ,          HospitalizationTimeAmbulance:
                             Hospitalization_Time_hour:NEXT(1$);


;
;
;     Model statements for module:  DiscreteProcessing.Process 2 (PreTraige)
;
1$            ASSIGN:        PreTraige.NumberIn=PreTraige.NumberIn + 1:
                             PreTraige.WIP=PreTraige.WIP+1;
601$          QUEUE,         PreTraige.Queue;
600$          SEIZE,         2,VA:
                             Paramedic,1:NEXT(599$);

599$          DELAY:         MinutesToBaseTime(Triangular(30,60,90)),,VA;
598$          RELEASE:       Paramedic,1;
646$          ASSIGN:        PreTraige.NumberOut=PreTraige.NumberOut + 1:
                             PreTraige.WIP=PreTraige.WIP-1:NEXT(5$);


;
;
;     Model statements for module:  DiscreteProcessing.Assign 6 (Patient Type Ambulance)
;
5$            ASSIGN:        Patient_Proiority=DISC(0.338, 1, 0.6852, 2,0.9121, 3, 0.9908, 4, 1.0, 5):NEXT(6$);


;
;
;     Model statements for module:  Decisions.Decide 2 (Does the patient need Urgent care)
;
6$            BRANCH,        1:
                             If,Patient_Proiority==1,38$,Yes:
                             If,Patient_Proiority==2,39$,Yes:
                             If,Patient_Proiority==3,40$,Yes:
                             If,Patient_Proiority==4,41$,Yes:
                             Else,42$,Yes;

;
;
;     Model statements for module:  InputOutput.File 2 (HospitalizationTimeWalkIns)
;
HospitalizationTimeWalkIns_RH READ, HospitalizationTimeWalkIns:;
651$          DISPOSE:       No;


;
;
;     Model statements for module:  InputOutput.File 3 (HospitalizationTimeAmbulance)
;
HospitalizationTimeAmbulance_RH READ, HospitalizationTimeAmbulance:;
652$          DISPOSE:       No;







