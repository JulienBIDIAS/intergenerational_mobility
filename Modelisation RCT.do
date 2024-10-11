*********************************************************************

***   TP EVALUATION D'IMPACT 

*********************************************************************



clear                                                   
set more off  
 
global workD "C:\Livre_ISE3\MICRO SIM EVALUATION IMPACT\TP_evaluation_impact"
global PrimD "$workD\PrimaryData"
global TempD "$workD\TempData"
global SecD  "$workD\SecondaryData"
global ProgD "$workD\Programs" /* Pour les programmes*/

global ResultD "$workD\Output" /* Pour les résultats*/
**********************************************************************************************

cd "$ResultD"/*Repertoire par de travail par défaut*/ 

log using fichier.log

* Pour installer le toolkit
// net install ietoolkit , from("https://raw.githubusercontent.com/worldbank/ietoolkit/master/src") replace

use "$PrimD\pooled_hh_TP.dta", clear

* Se familiariser avec la base

describe

********************************************************************************************************************************************************************************************************************

****1.Présentez les statistiques descriptives des variables disponibles  dans la base avant intervention montrant les moyennes par groupe et la significativité des écarts ghana 2, perou 6, Honduras 3

* Ghana************


iebaltab control_min_market control_compounds control_g_hhsize control_assetindex control_intro_business control_tot_surface control_livestockindex control_primary_savings control_primary_age if country == 2, grpvar("treatment") totallabel(All)  total stats(desc(sd) pair(diff)) grouplabels(1 "Treatment" @ 0 "Control") rowvarlabels nonote control(0) groupcodes savexlsx("$ResultD\balancetable_2.xlsx") replace


* Perou******


iebaltab control_educ_head control_p_population control_p_dist_municipio  control_p_hhsize control_ppi_total if country == 6, grpvar("treatment") totallabel(All)  total stats(desc(sd) pair(diff)) grouplabels(1 "Treatment" @ 0 "Control") rowvarlabels nonote control(0) groupcodes savexlsx("$ResultD\balancetable_6.xlsx") replace


* Honduras*******

iebaltab control_head_female control_primeageadult control_h_hhsize control_kids control_cellular control_income_pc control_educ_head_ control_h_population control_h_dist_municipio if country == 3, grpvar("treatment") totallabel(All) total stats(desc(sd) pair(diff)) grouplabels(1 "Treatment" @ 0 "Control") rowvarlabels nonote control(0) groupcodes savexlsx("$ResultD\balancetable_3.xlsx") replace 

********************************************************************************************************************************************************************************************************************

***** les variables d'intérêt *******

gen medcons = .
forvalues i= 6 3 : 2  {
	qui summ iagri_month_bsl if country==`i', det
	display "Country `i' has `r(p50)' la médiane des revenus provenant de l'agriculture"
	replace medcons = `r(p50)' if country==`i'
}

twoway(kdensity iagri_month_bsl if treatment==0) (kdensity iagri_month_bsl if treatment==1), title(la distribution des revenus provenant de l'agri selon le groupe) legend(label(1 "Traité") label(2 "Controle"))
 
twoway(kdensity ctotal_pcmonth_bsl if treatment==0) (kdensity iagri_month_bsl if treatment==1), title(la distribution de la consommation selon le groupe) legend(label(1 "Traité") label(2 "Controle"))


tabstat iagri_month_bsl, statistics(n min mean sd max) columns(statistics) by(country)

tabstat ctotal_pcmonth_bsl, statistics(n min mean sd max) columns(statistics) by(country)

tabstat fs_adultskip_bsl, statistics(n min mean sd max) columns(statistics) by(country)


****************************************************

* Global

iebaltab iagri_month_bsl ctotal_pcmonth_bsl fs_adultskip_bsl, grpvar("treatment") totallabel(All) total stats(desc(sd) pair(diff)) grouplabels(1 "Treatment" @ 0 "Control") rowvarlabels nonote control(0) groupcodes savexlsx("$ResultD\balancetable_0.xlsx") replace


***Par pays 

*  Ghana
iebaltab iagri_month_bsl ctotal_pcmonth_bsl fs_adultskip_bsl if country==2, grpvar("treatment")  totallabel(All) total stats(desc(sd) pair(diff))  grouplabels(1 "Treatment" @ 0 "Control") rowvarlabels nonote control(0) groupcodes savexlsx("$ResultD\balance_interet_ghana.xlsx") replace


* Honduras
iebaltab iagri_month_bsl ctotal_pcmonth_bsl fs_adultskip_bsl if country==3, grpvar("treatment") totallabel(All) total stats(desc(sd) pair(diff))   grouplabels(1 "Treatment" @ 0 "Control") rowvarlabels nonote control(0) groupcodes savexlsx("$ResultD\balance_interet_honduras.xlsx") replace

* Perou

iebaltab iagri_month_bsl ctotal_pcmonth_bsl fs_adultskip_bsl if country==6, grpvar("treatment") totallabel(All) total stats(desc(sd) pair(diff))   grouplabels(1 "Treatment" @ 0 "Control") rowvarlabels nonote control(0) groupcodes savexlsx("$ResultD\balance_interet_perou.xlsx") replace 

***************************************************************************************************************************************************************

*** Attrition********
// / Evaluation de l'attrition en courte et longue periode

tab attrition_end country, col


tab attrition_fup country, col

tab attrition_end treatment, col
tab attrition_fup treatment, col


tab attrition_end if country==2
tab attrition_end if country==3
tab attrition_end if country==6
 
tab attrition_fup if country==2
tab attrition_fup if country==3
tab attrition_fup if country==6


sum attrition_end attrition_fup, detail


********************************************************************************************************************************************************************************************************************

*********************************2éme partie : Analyse des impacts à court terme et à moyen termes du programme*******************************************

********************************************************************************************************************************************************************************************************************


*** 4.une première estimation de l'impact moyen du traitement sur les 3 variables de résultats sur l'ensemble des 3 pays en tenant compte de la stratification des enquêtes, en incluant dans les régressions des indicatrices par pays et les variables d'intérêt en baseline comme variables explicatives

*****A court terme
*iagri_month_end  
*ctotal_pcmonth_end
*fs_adultskip_end

***************************************************
* A court terme


areg iagri_month_end treatment iagri_month_bsl m_iagri_month_bsl i.country, absorb(geo_cluster) cluster(rand_unit)

outreg2 using "TABLEAU1.xls", stats(coef se) ct(Household Income from Agriculture (2014 USD PPP)) label addstat(R-carré, e(r2), Observations, e(N)) nocon nor2 word excel dec(3) noobs replace 

******************
areg ctotal_pcmonth_end treatment ctotal_pcmonth_bsl m_ctotal_pcmonth_bsl i.country , absorb(geo_cluster) cluster(rand_unit)	

outreg2 using "TABLEAU1.xls", stats(coef se) ct(monthly per capita consumption(2014 USD PPP)) label addstat(R-carré, e(r2), Observations, e(N)) nocon nor2 word excel dec(3) noobs append 
				  
******************
areg fs_adultskip_end treatment fs_adultskip_bsl m_fs_adultskip_bsl i.country, absorb(geo_cluster) cluster(rand_unit)

outreg2 using "TABLEAU1.xls", stats(coef se) ct(No adults skip meals) label addstat(R-carré, e(r2), Observations, e(N)) nocon nor2 word excel dec(3) noobs append


**************************************************

* A moyen terme

areg iagri_month_fup treatment iagri_month_bsl m_iagri_month_bsl i.country, absorb(geo_cluster) cluster(rand_unit)

outreg2 using "TABLEAU2.xls", stats(coef se) ct(Household Income from Agriculture (2014 USD PPP)) label addstat(R-carré, e(r2), Observations, e(N)) nocon nor2 word excel dec(3) noobs replace 

*************
				  
areg ctotal_pcmonth_fup treatment ctotal_pcmonth_bsl m_ctotal_pcmonth_bsl i.country, absorb(geo_cluster) cluster(rand_unit)

outreg2 using "TABLEAU2.xls", stats(coef se) ct(monthly per capita consumption(2014 USD PPP)) label addstat(R-carré, e(r2), Observations, e(N)) nocon nor2 word excel dec(3) noobs append 

***************
			  
areg fs_adultskip_fup treatment fs_adultskip_bsl m_fs_adultskip_bsl i.country, absorb(geo_cluster) cluster(rand_unit)

outreg2 using "TABLEAU2.xls", stats(coef se) ct(No adults skip meals) label addstat(R-carré, e(r2), Observations, e(N)) nocon nor2 word excel dec(3) noobs append


********************************************************************************************************************************************************************************************************************

****5.	Pensez-vous qu'il est nécessaire d'ajouter des variables de contrôle ? pourquoi et lesquelles ? est-ce que les résultats diffèrent par rapport à la première estimation ?


/////// Oui. En considérant la liste des variables de controle par pays, le ttest a montré que les variables suivantes peuvent étre incluses dans les regressions

* A court terme

areg iagri_month_end treatment iagri_month_bsl m_iagri_month_bsl control_p_population control_primeageadult control_h_hhsize control_kids control_educ_head control_h_population control_compounds control_livestockindex i.country, absorb(geo_cluster) cluster(rand_unit)

outreg2 using "TABLEAU3.xls", stats(coef se) ct(Household Income from Agriculture (2014 USD PPP)) label addstat(R-carré, e(r2), Observations, e(N)) nocon nor2 word excel dec(3) noobs replace 

*******************************************

areg ctotal_pcmonth_end treatment ctotal_pcmonth_bsl m_ctotal_pcmonth_bsl control_p_population control_primeageadult control_h_hhsize control_kids control_educ_head control_h_population control_compounds control_livestockindex i.country, absorb(geo_cluster) cluster(rand_unit)

outreg2 using "TABLEAU3.xls", stats(coef se) ct(monthly per capita consumption(2014 USD PPP)) label addstat(R-carré, e(r2), Observations, e(N)) nocon nor2 word excel dec(3) noobs append 

*********************************************
areg fs_adultskip_end treatment fs_adultskip_bsl m_fs_adultskip_bsl control_p_population control_primeageadult control_h_hhsize control_kids control_educ_head control_h_population control_compounds control_livestockindex i.country, absorb(geo_cluster) cluster(rand_unit)

outreg2 using "TABLEAU3.xls", stats(coef se) ct(No adults skip meals) label addstat(R-carré, e(r2), Observations, e(N)) nocon nor2 word excel dec(3) noobs append


****************************************************


** A moyen terme

areg iagri_month_fup treatment iagri_month_bsl m_iagri_month_bsl control_p_population control_primeageadult control_h_hhsize control_kids control_educ_head control_h_population control_compounds control_livestockindex  i.country, absorb(geo_cluster) cluster(rand_unit)

outreg2 using "TABLEAU4.xls", stats(coef se) ct(Household Income from Agriculture (2014 USD PPP)) label addstat(R-carré, e(r2), Observations, e(N)) nocon nor2 word excel dec(3) noobs replace 

**************************************************

areg ctotal_pcmonth_fup treatment ctotal_pcmonth_bsl m_ctotal_pcmonth_bsl control_p_population control_primeageadult control_h_hhsize control_kids control_educ_head control_h_population control_compounds control_livestockindex i.country, absorb(geo_cluster) cluster(rand_unit)

outreg2 using "TABLEAU4.xls", stats(coef se) ct(monthly per capita consumption(2014 USD PPP)) label addstat(R-carré, e(r2), Observations, e(N)) nocon nor2 word excel dec(3) noobs append 


***************************************************

areg fs_adultskip_fup treatment fs_adultskip_bsl m_fs_adultskip_bsl control_p_population control_primeageadult control_h_hhsize control_kids control_educ_head control_h_population control_compounds control_livestockindex i.country, absorb(geo_cluster) cluster(rand_unit)

outreg2 using "TABLEAU4.xls", stats(coef se) ct(No adults skip meals) label addstat(R-carré, e(r2), Observations, e(N)) nocon nor2 word excel dec(3) noobs append


******6.	Faites un résumé de vos résultats. Trouvez-vous que le programme a eu un effet important à court et à moyen termes ? 


************Troisième partie : Hétérogénéité de l'impact*******************************

******7.	Y a-t-il des effets différents selon le pays de résidence des ménages ? Présentez la manière dont vous avez procédé pour examiner l'hétérogénéité des effets par pays et commentez les résultats.

****A court terme****
// Je ne connais pas cette commaned "hte"

************Troisième partie : Hétérogénéité de l'impact*******************************

******7. Y a-t-il des effets différents selon le pays de résidence des ménages ? Présentez la manière dont vous avez procédé pour examiner l'hétérogénéité des effets par pays et commentez les résultats.

* Avec le test de Chow


*** CONSO TOTAL MENSUELLE/ TETE
* Court terme
areg ctotal_pcmonth_end treatment ctotal_pcmonth_bsl m_ctotal_pcmonth_bsl control_p_population control_primeageadult control_h_hhsize control_kids control_educ_head control_h_population control_compounds control_livestockindex if country==3, absorb(geo_cluster) cluster(rand_unit)
scalar scr_hondu = e(rss)

areg ctotal_pcmonth_end treatment ctotal_pcmonth_bsl m_ctotal_pcmonth_bsl control_p_population control_primeageadult control_h_hhsize control_kids control_educ_head control_h_population control_compounds control_livestockindex if country==6, absorb(geo_cluster) cluster(rand_unit)
scalar scr_peru = e(rss)

areg ctotal_pcmonth_end treatment ctotal_pcmonth_bsl m_ctotal_pcmonth_bsl control_p_population control_primeageadult control_h_hhsize control_kids control_educ_head control_h_population control_compounds control_livestockindex if country!=2, absorb(geo_cluster) cluster(rand_unit)
scalar scr = e(rss)
scalar pop = e(N)

scalar chow_stat = ((scr-(scr_hondu+scr_peru))/(scr_hondu+scr_peru))*((pop-2*28)/28)
scalar chow_stat_rounded = round(chow_stat, 0.001)
di chow_stat_rounded
di 1 - F(28, pop-2*28, chow_stat_rounded)

*** CONSO TOTAL MENSUELLE/ TETE
* Long terme
areg ctotal_pcmonth_fup treatment ctotal_pcmonth_bsl m_ctotal_pcmonth_bsl control_p_population control_primeageadult control_h_hhsize control_kids control_educ_head control_h_population control_compounds control_livestockindex if country==3, absorb(geo_cluster) cluster(rand_unit)
scalar scr_hondu = e(rss)

areg ctotal_pcmonth_fup treatment ctotal_pcmonth_bsl m_ctotal_pcmonth_bsl control_p_population control_primeageadult control_h_hhsize control_kids control_educ_head control_h_population control_compounds control_livestockindex if country==6, absorb(geo_cluster) cluster(rand_unit)
scalar scr_peru = e(rss)

areg ctotal_pcmonth_fup treatment ctotal_pcmonth_bsl m_ctotal_pcmonth_bsl control_p_population control_primeageadult control_h_hhsize control_kids control_educ_head control_h_population control_compounds control_livestockindex if country!=2, absorb(geo_cluster) cluster(rand_unit)
scalar scr = e(rss)
scalar pop = e(N)

scalar chow_stat = ((scr-(scr_hondu+scr_peru))/(scr_hondu+scr_peru))*((pop-2*28)/28)
scalar chow_stat_rounded = round(chow_stat, 0.001)
di chow_stat_rounded
di 1-F(28, pop-2*28, chow_stat_rounded)

*** REVENUS AGRICOLES MENSUELS
* Court terme
areg iagri_month_end treatment iagri_month_bsl m_iagri_month_bsl control_p_population control_primeageadult control_h_hhsize control_kids control_educ_head control_h_population control_compounds control_livestockindex if country==3, absorb(geo_cluster) cluster(rand_unit)
scalar scr_hondu = e(rss)

areg iagri_month_end treatment iagri_month_bsl m_iagri_month_bsl control_p_population control_primeageadult control_h_hhsize control_kids control_educ_head control_h_population control_compounds control_livestockindex if country==6, absorb(geo_cluster) cluster(rand_unit)
scalar scr_peru = e(rss)

areg iagri_month_end treatment iagri_month_bsl m_iagri_month_bsl control_p_population control_primeageadult control_h_hhsize control_kids control_educ_head control_h_population control_compounds control_livestockindex if country!=2, absorb(geo_cluster) cluster(rand_unit)
scalar scr = e(rss)
scalar pop = e(N)

scalar chow_stat = ((scr-(scr_hondu+scr_peru))/(scr_hondu+scr_peru))*((pop-2*28)/28)
scalar chow_stat_rounded = round(chow_stat, 0.001)
di chow_stat_rounded
di 1-F(28, pop-2*28, chow_stat_rounded)

* Long terme
areg iagri_month_fup treatment iagri_month_bsl m_iagri_month_bsl control_p_population control_primeageadult control_h_hhsize control_kids control_educ_head control_h_population control_compounds control_livestockindex if country==3, absorb(geo_cluster) cluster(rand_unit)
scalar scr_hondu = e(rss)

areg iagri_month_fup treatment iagri_month_bsl m_iagri_month_bsl control_p_population control_primeageadult control_h_hhsize control_kids control_educ_head control_h_population control_compounds control_livestockindex if country==6, absorb(geo_cluster) cluster(rand_unit)
scalar scr_peru = e(rss)

areg iagri_month_fup treatment iagri_month_bsl m_iagri_month_bsl control_p_population control_primeageadult control_h_hhsize control_kids control_educ_head control_h_population control_compounds control_livestockindex if country!=2, absorb(geo_cluster) cluster(rand_unit)
scalar scr = e(rss)
scalar pop = e(N)

scalar chow_stat = ((scr-(scr_hondu+scr_peru))/(scr_hondu+scr_peru))*((pop-2*28)/28)
scalar chow_stat_rounded = round(chow_stat, 0.001)
di chow_stat_rounded
di 1-F(28, pop-2*28, chow_stat_rounded)

*** SAUT DE REPAS
* Court terme
areg fs_adultskip_end treatment fs_adultskip_bsl m_fs_adultskip_bsl control_p_population control_primeageadult control_h_hhsize control_kids control_educ_head control_h_population control_compounds control_livestockindex if country==3, absorb(geo_cluster) cluster(rand_unit)
scalar scr_hondu = e(rss)

areg fs_adultskip_end treatment fs_adultskip_bsl m_fs_adultskip_bsl control_p_population control_primeageadult control_h_hhsize control_kids control_educ_head control_h_population control_compounds control_livestockindex if country==6, absorb(geo_cluster) cluster(rand_unit)
scalar scr_peru = e(rss)

areg fs_adultskip_end treatment fs_adultskip_bsl m_fs_adultskip_bsl control_p_population control_primeageadult control_h_hhsize control_kids control_educ_head control_h_population control_compounds control_livestockindex if country!=2, absorb(geo_cluster) cluster(rand_unit)
scalar scr = e(rss)
scalar pop = e(N)

scalar chow_stat = ((scr-(scr_hondu+scr_peru))/(scr_hondu+scr_peru))*((pop-2*28)/28)
scalar chow_stat_rounded = round(chow_stat, 0.001)
di chow_stat_rounded
di 1-F(28, pop-2*28, chow_stat_rounded)

* Long terme
areg fs_adultskip_fup treatment fs_adultskip_bsl m_fs_adultskip_bsl control_p_population control_primeageadult control_h_hhsize control_kids control_educ_head control_h_population control_compounds control_livestockindex if country==3, absorb(geo_cluster) cluster(rand_unit)
scalar scr_hondu = e(rss)

areg fs_adultskip_fup treatment fs_adultskip_bsl m_fs_adultskip_bsl control_p_population control_primeageadult control_h_hhsize control_kids control_educ_head control_h_population control_compounds control_livestockindex if country==6, absorb(geo_cluster) cluster(rand_unit)
scalar scr_peru = e(rss)

areg fs_adultskip_fup treatment fs_adultskip_bsl m_fs_adultskip_bsl control_p_population control_primeageadult control_h_hhsize control_kids control_educ_head control_h_population control_compounds control_livestockindex if country!=2, absorb(geo_cluster) cluster(rand_unit)
scalar scr = e(rss)
scalar pop = e(N)

scalar chow_stat = ((scr-(scr_hondu+scr_peru))/(scr_hondu+scr_peru))*((pop-2*28)/28)
scalar chow_stat_rounded = round(chow_stat, 0.001)
di chow_stat_rounded
di 1-F(28, pop-2*28, chow_stat_rounded)


*Première option

gen trat_ghana = treatment* (country==2)
gen trat_honduras = treatment* (country==3)  
gen trat_peru = treatment* (country==6)


areg iagri_month_fup trat_ghana trat_honduras trat_peru iagri_month_bsl m_iagri_month_bsl control_p_population control_primeageadult control_h_hhsize control_kids control_educ_head control_h_population control_compounds control_livestockindex  i.country, absorb(geo_cluster) cluster(rand_unit)

matrix iagri_fup = e(b)'
matrix list iagri_fup

test trat_peru = trat_honduras = 0

* Deuxième option

foreach var in iagri_month_end ctotal_pcmonth_end fs_adultskip_end iagri_month_fup ctotal_pcmonth_fup fs_adultskip_fup{

    qui regress `var' treatment##i.country, vce(cluster geo_cluster)

    test 1.treatment#3.country = 1.treatment#6.country = 0

    qui margins, dydx(*)

    qui marginsplot, name(mplot_`var', replace) title("Effets marginaux pour `var'")

}

graph combine mplot_iagri_month_end mplot_ctotal_pcmonth_end mplot_fs_adultskip_end,title("Effets marginaux pour différentes variables de résultat")



 
**************************************Quatrième partie : identification d'effets d'externalité**************

****8. Le programme a-t-il eu des effets d'externalité (spillover) ? Identifiez ces effets en prenant, un des pays de votre choix et en examinant les variables de résultats des ménages résidant dans les villages avec des ménages traités. Commentez vos résultats à court et à moyen

* o spillover_treat :  Control households in treatment villages vs. Pure control                                                households

* A court terme

regress iagri_month_end spillover_treat iagri_month_bsl m_iagri_month_bsl control_primeageadult control_h_hhsize control_kids control_h_population  if country == 3, vce(cluster geo_cluster)

outreg using spill_end, bdec(5) varlabels replace              ///
                  starlevels(10 5 1) sigsymbols(*,**,***) summstat(F \ r2_a)  ///
                  summtitle(F statistic \ Adjusted R-squared) summdec(3 3)

reg ctotal_pcmonth_end spillover_treat ctotal_pcmonth_bsl m_ctotal_pcmonth_bsl control_primeageadult control_h_hhsize control_kids control_h_population  if country == 3, vce(cluster geo_cluster)

outreg using spill_end, bdec(5) varlabels replace              ///
                  starlevels(10 5 1) sigsymbols(*,**,***) summstat(F \ r2_a)  ///
                  summtitle(F statistic \ Adjusted R-squared) summdec(3 3) merge

reg fs_adultskip_end spillover_treat fs_adultskip_bsl m_fs_adultskip_bsl control_primeageadult control_h_hhsize control_kids control_h_population  if country == 3, vce(cluster geo_cluster)

outreg using spill_end, bdec(5) varlabels replace              ///
                  starlevels(10 5 1) sigsymbols(*,**,***) summstat(F \ r2_a)  ///
                  summtitle(F statistic \ Adjusted R-squared) summdec(3 3) merge


* A moyen terme

reg iagri_month_fup spillover_treat iagri_month_bsl m_iagri_month_bsl control_primeageadult control_h_hhsize control_kids control_h_population  if country == 3, vce(cluster geo_cluster)

outreg using spill_fup, bdec(5) varlabels replace              ///
                  starlevels(10 5 1) sigsymbols(*,**,***) summstat(F \ r2_a)  ///
                  summtitle(F statistic \ Adjusted R-squared) summdec(3 3)

reg ctotal_pcmonth_fup spillover_treat ctotal_pcmonth_bsl m_ctotal_pcmonth_bsl control_primeageadult control_h_hhsize control_kids control_h_population  if country == 3, vce(cluster geo_cluster)

outreg using spill_fup, bdec(5) varlabels replace              ///
                  starlevels(10 5 1) sigsymbols(*,**,***) summstat(F \ r2_a)  ///
                  summtitle(F statistic \ Adjusted R-squared) summdec(3 3) merge

reg fs_adultskip_fup spillover_treat fs_adultskip_bsl m_fs_adultskip_bsl control_primeageadult control_h_hhsize control_kids control_h_population  if country == 3, vce(cluster geo_cluster)

outreg using spill_fup, bdec(5) varlabels replace              ///
                  starlevels(10 5 1) sigsymbols(*,**,***) summstat(F \ r2_a)  ///
                  summtitle(F statistic \ Adjusted R-squared) summdec(3 3) merge
log close

