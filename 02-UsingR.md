
Survival analysis in R
=========================
Install and load required R package

We’ll use two R packages:

1. survival for computing survival analyses
2. survminer for summarizing and visualizing the results of survival analysis

Install the packages




```R
install.packages(c("survival", "survminer"))
#Load the packages
library("survival")
library("survminer")

```

    Installing packages into '/home/nbcommon/R'
    (as 'lib' is unspecified)
    Loading required package: ggplot2


Example data sets

We’ll use the lung cancer data available in the survival package.





```R
data("lung")
head(lung)
```


<table>
<thead><tr><th>inst</th><th>time</th><th>status</th><th>age</th><th>sex</th><th>ph.ecog</th><th>ph.karno</th><th>pat.karno</th><th>meal.cal</th><th>wt.loss</th></tr></thead>
<tbody>
	<tr><td> 3  </td><td> 306</td><td>2   </td><td>74  </td><td>1   </td><td>1   </td><td> 90 </td><td>100 </td><td>1175</td><td>NA  </td></tr>
	<tr><td> 3  </td><td> 455</td><td>2   </td><td>68  </td><td>1   </td><td>0   </td><td> 90 </td><td> 90 </td><td>1225</td><td>15  </td></tr>
	<tr><td> 3  </td><td>1010</td><td>1   </td><td>56  </td><td>1   </td><td>0   </td><td> 90 </td><td> 90 </td><td>  NA</td><td>15  </td></tr>
	<tr><td> 5  </td><td> 210</td><td>2   </td><td>57  </td><td>1   </td><td>1   </td><td> 90 </td><td> 60 </td><td>1150</td><td>11  </td></tr>
	<tr><td> 1  </td><td> 883</td><td>2   </td><td>60  </td><td>1   </td><td>0   </td><td>100 </td><td> 90 </td><td>  NA</td><td> 0  </td></tr>
	<tr><td>12  </td><td>1022</td><td>1   </td><td>74  </td><td>1   </td><td>1   </td><td> 50 </td><td> 80 </td><td> 513</td><td> 0  </td></tr>
</tbody>
</table>



* inst: Institution code
* time: Survival time in days
* status: censoring status 1=censored, 2=dead
* age: Age in years
* sex: Male=1 Female=2
* ph.ecog: ECOG performance score (0=good 5=dead)
* ph.karno: Karnofsky performance score (bad=0-good=100) rated by physician
* pat.karno: Karnofsky performance score as rated by patient
* meal.cal: Calories consumed at meals
* wt.loss: Weight loss in last six months
