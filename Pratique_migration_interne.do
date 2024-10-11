cd "C:\Users\Julien\Desktop\JULIEN\Livre_ISE3\Economie du travail"

use "s13_2_me_SEN2021", clear


*************Création de la variable qui capte la migration interne


gen mig = 1 if s13q19 == 3
replace mig = 0 if mig ==.
label def cod 1"Est un migrant interne" 0"N'est pas un migrant interne"
label value mig cod
label variable mig "Identification de migrant interne"



replace s13q16=13 if s13q16==9999
replace s13q15=1 if s13q15==6
replace s13q21=3 if s13q21==10
replace s13q21=1 if s13q21==10


***Age

sum s13q14 if s13q14!=9999

recode s13q14 (min/27=1 "15 à 27 ans") (28/42=2 "28 à 42 ans") (43/57=3 "43 à 57 ans") (58/62=4 "58 à 62 ans") (63/77= 5 "63 à 77 ans") (78/max=6 "78 ans et plus"), gen (tranche_age)

asdoc tab tranche_age mig



****32% des enquêtés sont des migrants internes
numlabel, add

global var s13q13 s13q16 s13q15 s13q17 s13q20 s13q21 s13q22b tranche_age


foreach x in $var{
	asdoc tab `x' mig, nofreq row save(bivarie.doc) append
}


* traitement 

rename s13q16 stat_pro
rename s13q13 sexe
rename s13q15 niv_inst
rename s13q20 motif_trans
rename s13q21 mod_trans
rename s13q22b freq
rename s13q22a montant_env



* univarié 

asdoc tab1 stat_pro sexe niv_inst motif_trans mod_trans freq, save(doc.doc) replace 



* Modèle logit 


logit mig i.sexe i.stat_pro i.niv_inst montant_env i.tranche_age i.motif_trans i.mod_trans i.freq, vce(robust)

* Export 

eststo oddp1

outreg2 [oddp1] using "Coef.xls", stats(coef se) bracket(se) aster label ct(`x') addstat(Pseudo R2, e(r2_p), Observations, e(N)) nocon nor2 word excel dec(3) noobs replace


* Tests 

estat class


* courbe de ROC

lroc
graph export "FigureI.png",replace
outreg2 using "results_estimation.xls", replace ctitle("coeff") dec(3)


**Avec les Odds ratio


* Odds ratios par pays (pondérés)


logit mig i.sexe i.stat_pro i.niv_inst montant_env i.tranche_age i.motif_trans i.mod_trans i.freq, or nolog

eststo oddp

outreg2 [oddp] using "OR.xls", eform stats(coef se) bracket(se) aster label ct(`x') addstat(Pseudo R2, e(r2_p), Observations, e(N)) nocon nor2 word excel dec(3) noobs replace


* Tests 

estat class
estat gof


* Courbe de ROC 
lroc
graph export "FigureII.png",replace
