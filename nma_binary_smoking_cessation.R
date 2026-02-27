install.packages("netmeta")
library(netmeta)

#loading a dataset included in netmeta
data("smokingcessation", package = "netmeta")
str(smokingcessation)
head(smokingcessation)
#adding the missing column for study ID
smokingcessation$studlab <- paste0("Study_", 1:nrow(smokingcessation))

#placing the study ID column as first one
smokingcessation <- smokingcessation[, 
  c("studlab", setdiff(names(smokingcessation), "studlab"))] 
  
#conducting pairwise meta-analysis to obtain relative treatment effects (log odds ratios) and corresponding standard errors from each study
pw <- pairwise(
  treat = list(treat1, treat2, treat3),
  event = list(event1, event2, event3),
  n = list(n1, n2, n3),
  studlab = studlab,
  data = smokingcessation,
  sm = "OR"
)
head (pw)

#conducting NMA on pw
net1 <- netmeta(
  TE,
  seTE,
  treat1,
  treat2,
  studlab,
  data = pw,
  sm = "OR",
  random = TRUE,
  reference.group = "A"   
)
summary (net1)

#obtaining the graphical presentation of the network
netgraph(net1,multiarm=TRUE, plastic = TRUE)

#producing the league table
netleague(net1, digits = 2)

#ranking of treatments
netrank(net1, small.values = "good")
rankogram(net1, small.values="good")

#producing a forest plot
forest(net1)

#evaluating heterogeneity and inconsistenacy
net1$Q
net1$df.Q
net1$tau
netsplit(net1)
netheat(net1)

#conducting sensitivity analysis - one out
netimpact(net1)
