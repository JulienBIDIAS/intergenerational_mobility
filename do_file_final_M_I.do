*<<<<<<<<< THEME: MOBILITE INTERGENERATIONNELLE SECTEORIELLE : ANALYSE DES DYNAMIQUES ET DETERMINANTS>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


******** GROUPE DE TRAVAIL ISE-3: SISSOKO DAOUDA & BIDIAS ASSALA JULIEN PARFAIT *********************


****  CHARGEMENT DE LA BASE DE DONNEE ******

clear all 


version 18.0

set more off 


cd "C:\Users\Julien\Desktop\JULIEN\MEMOIRE_GT\4.Chapitre_3 Présentation des résultats et discussion\STAT DESCP CORRIGE"


use "Base_finale_1", clear 

tab cohorte, m

replace cohorte = 1 if cohorte==.


************************************************************************************************************


** 1. Statistiques descriptives des variables d'étude pour l'ensemble des pays ****

asdoc tab1 secteur_fils secteur_pere cohorte instruction_pere milieu_residence [fweight=round(hhweight)], save(stats_desc.doc)

************************************************************************************************************


*** 1.1 Statistiques des variables d'étude par pays (A METTRE EN ANNEXE) ***********

forvalues x=1/8{
	tab1 secteur_fils secteur_pere cohorte instruction_pere if pays==`x' [fweight=round(hhweight)]
} 

************************************************************************************************************

*** 1.2 Effectifs des cohortes par pays


forvalues x=1/8{
	asdoc tab cohorte if pays== `x' , m save(cohorte_pays.doc) append 
	}

** NB: les résultats sont représentatifs au niveau national, c'est-à-dire que nous avons pondéré les estimations**

************************************************************************************************************

** 2. Statistiques descriptives des variables de l'étude par pays 

forvalues x=1/8 {
	 asdoc tab1 secteur_fils secteur_pere cohorte instruction_pere milieu_residence if pays==`x' [fweight=round(hhweight)], save(stat_ensemble.doc)
}


************************************************************************************************************


** 3. cohorte des individus et leur secteur d'activité


by pays:  tab cohort secteur_fils , freq row 


by pays: asdoc tab cohorte secteur_fils  [fweight=round(hhweight)], nofreq row save(cohtefils.doc)


********************************************************************************************************


** 4. Tables de contingence du niveau d'éducation des parents et du secteur d'activité des enfants 

* set scheme white_tableau

tab instruction_pere [fweight=round(hhweight)]

tab instruction_pere secteur_fils [fweight=round(hhweight)], row nofreq


spineplot secteur_fils instruction_pere [fweight=round(hhweight)], xlabel(, angle(v) axis(2) labsize(tiny)) xtitle("", axis(2)) xtitle("pourcentage suivant le niveau d'instruction des parents") ylabel( ,axis(2)) ytitle("probabilité conditionnelle que l'enfant se retrouve dans un secteur", axis(2))



********************************************************************************************************


** 5. secteur d'activité des parents et secteur d'activité des individus

by pays: asdoc tab secteur_pere [fweight=round(hhweight)],save(resut10.doc)


by pays: asdoc tab secteur_fils [fweight=round(hhweight)],save(resut11.doc)



********************************************************************************************************


** 6.  Matrice de destiné sociale ou matrice de transition


by pays: asdoc tab secteur_pere secteur_fils  [fweight=round(hhweight)], nofreq row save(resut5.doc)


by pays:asdoc tab secteur_pere secteur_fils  [fweight=round(hhweight)], nofreq row col save(final.doc) 


********************************************************************************************************

** 7. Matrice de transition par cohortes : pour récupérer la mobilité ascendante par cohortes


* cohorte 0 

forvalues y=1/8{
	asdoc tab secteur_pere secteur_fils if cohorte==0 & pays== `y' [fweight=round(hhweight)], nofreq row save(cohorte_secteurfils.doc)
	}
	
* cohorte 1

forvalues y=1/8{
	asdoc tab secteur_pere secteur_fils if cohorte==1 & pays== `y' , nofreq row save(cohorte_secteurfils.doc) append
	}
	
	
* cohorte 2

	
forvalues y=1/8{
	asdoc tab secteur_pere secteur_fils if cohorte==2 & pays== `y' , nofreq row save(cohorte_secteurfils.doc) append
	}	
	
* cohorte 3


forvalues y=1/8{
	asdoc tab secteur_pere secteur_fils if cohorte==3 & pays== `y' , nofreq row save(cohorte_secteurfils.doc) append
	}
	
	
* cohorte 4

forvalues y=1/8{
	asdoc tab secteur_pere secteur_fils if cohorte==4 & pays== `y' , nofreq row save(cohorte_secteurfils.doc) append
	}
	
	
* cohorte 5

forvalues y=1/8{
	asdoc tab secteur_pere secteur_fils if cohorte==5 & pays== `y' , nofreq row save(cohorte_secteurfils.doc) append
	}
	
	
* cohorte 6


forvalues y=1/8{
	asdoc tab secteur_pere secteur_fils if cohorte==6 & pays== `y' , nofreq row save(cohorte_secteurfils.doc) append
	}
	
	
********************************************************************************************************



* <<<<<<<<<<<<<Estimations>>>>>>>>>>>>>>>>>>>>>>>>



** 8. Mobilité intergénérationnelle nette (Odds ratios)

* Odds ratios par pays (pondérés)

forvalues x=1/8{
		logit secteur_fils 1.secteur_pere [fweight=round(hhweight)] if pays==`x', or nolog 
	eststo oddp_`x'
	outreg2 [oddp_`x'] using "fluiditep.xls", eform stats(coef se) bracket(se) aster label ct(`x') addstat(Pseudo R2, e(r2_p), Observations, e(N)) nocon nor2 word excel dec(3) noobs append
	}

********************************************************************************************************

* Odds ratios par pays et par cohortes


* 1st cohort

forvalues x=1/8{
		logit secteur_fils 1.secteur_pere [fweight=round(hhweight)] if pays==`x' | cohorte==0, or nolog
		eststo oddp_`x'
		outreg2 [oddp_`x'] using "fluiditecoh.xls", eform ci bracket aster label ct(No) addstat(Pseudo R2, e(r2_p), Observations, e(N)) nocon nor2 excel dec(3) noobs append
		}
		
* 2nd cohort

forvalues x=1/8{
		logit secteur_fils i.secteur_pere [fweight=round(hhweight)] if pays==`x' | cohorte==1, or nolog
		eststo oddp_`x'
		outreg2 [oddp_`x'] using "fluiditecoh.xls", eform ci bracket aster label ct(No) addstat(Pseudo R2, e(r2_p), Observations, e(N)) nocon nor2 excel dec(3) noobs append
		}
		

* 3rd cohort


forvalues x=1/8{
		logit secteur_fils i.secteur_pere [fweight=round(hhweight)] if pays==`x' | cohorte==2, or nolog
		eststo oddp_`x'
		outreg2 [oddp_`x'] using "fluiditecoh.xls", eform ci bracket aster label ct(No) addstat(Pseudo R2, e(r2_p), Observations, e(N)) nocon nor2 excel dec(3) noobs append
		}
		
		
* 4th cohort

forvalues x=1/8{
		logit secteur_fils i.secteur_pere [fweight=round(hhweight)] if pays==`x' | cohorte==3, or nolog
		eststo oddp_`x'
		outreg2 [oddp_`x'] using "fluiditecoh.xls", eform ci bracket aster label ct(No) addstat(Pseudo R2, e(r2_p), Observations, e(N)) nocon nor2 excel dec(3) noobs append
		}
	
* 5th cohort
	
forvalues x=1/8{
		logit secteur_fils i.secteur_pere [fweight=round(hhweight)] if pays==`x' | cohorte==4, or nolog
		eststo oddp_`x'
		outreg2 [oddp_`x'] using "fluiditecoh.xls", eform ci bracket aster label ct(No) addstat(Pseudo R2, e(r2_p), Observations, e(N)) nocon nor2 excel dec(3) noobs append
		}
		
* 6th cohort
		
forvalues x=1/8{
		logit secteur_fils i.secteur_pere [fweight=round(hhweight)] if pays==`x' | cohorte==5, or nolog
		eststo oddp_`x'
		outreg2 [oddp_`x'] using "fluiditecoh.xls", eform ci bracket aster label ct(No) addstat(Pseudo R2, e(r2_p), Observations, e(N)) nocon nor2 excel dec(3) noobs append
		}
		
* 7th cohort

forvalues x=1/8{
		logit secteur_fils i.secteur_pere [fweight=round(hhweight)] if pays==`x' | cohorte==6, or nolog
		eststo oddp_`x'
		outreg2 [oddp_`x'] using "fluiditecoh.xls", eform ci bracket aster label ct(No) addstat(Pseudo R2, e(r2_p), Observations, e(N)) nocon nor2 excel dec(3) noobs append
		}



********************************************************************************************************


** 9. Modélisation Unidiff

/* 
Dans cette partie, nous estimons un modèle unidif pour capter les dégré d'ingélité d'accès à un secteur pour les enfants  selon les caractéristqiues des parents
*/

** Génération des fréquences 


contract secteur_pere secteur_fils pays [fweight=round(hhweight)], nomiss

** Modélisation 


net search unidiff // Ensuite installer 


unidiff _freq, row(secteur_pere) col(secteur_fils) layer(pays) effect(mult) pattern(fi) lambda(rawlog) refcat(5)


********************************************************************************************************


** 10. Estimation du modèle logit (M.I nette ascendante)

*** 10.1 Odds ratios pondérés sans le niveau d'éducation du père et 


forvalues x=1/8{
	logit secteur_fils 0.secteur_pere i.cohorte [fweight=round(hhweight)] if pays==`x', or robust nolog 
	eststo modeles_`x'
	outreg2 [modeles_`x'] using "OR_effectp.xls", eform label ct(No) addstat(Observations, e(N), Log.Likelihood, e(ll), Pseudo R2, e(r2_p)) nocon nor2 excel dec(3) noobs append
		}
		


*** 10.2 Odds ratios Non pondérés pour récupérer les tailles d'échantillon 


forvalues x=1/8{
	logit secteur_fils 0.secteur_pere i.cohorte if pays==`x', or robust nolog 
	eststo modeles_`x'
	outreg2 [modeles_`x'] using "OR_effectnp.xls", eform label ct(No) addstat(Observations, e(N), Log.Likelihood, e(ll), Pseudo R2, e(r2_p)) nocon nor2 excel dec(3) noobs append
		}
		
		
*** 10.3 En ajoutant le niveau d'instruction des parents

forvalues x=1/8{
	logit secteur_fils 0.secteur_pere i.instruction_pere i.cohorte if pays==`x' [fweight=round(hhweight)], or robust nolog
	eststo m_`x'
	outreg2 [m_`x'] using "OR_nivinst.xls", stats(coef se) eform long label ct(No) addstat(Observations, e(N), Log.Likelihood, e(ll), Pseudo R2, e(r2_p)) nocon nor2 excel dec(3) noobs append
	}



** 11. modèle à équations structurelles ou modèle de pistes causales ***


sem (instruction_enfant -> secteur_fils, ) (instruction_pere -> instruction_enfant, ) (instruction_pere ->secteur_pere, ) (instruction_pere -> secteur_fils, ) (secteur_pere -> instruction_enfant, ) (secteur_pere -> secteur_fils, ) [pweight = hhweight], group(pays) method(mlmv) vce(robust) nocapslatent

estat teffects


* <<<<<<<<<<<<<<<<<< Fin >>>>>>>>>>>>>>>>>>>>>>>>>>


