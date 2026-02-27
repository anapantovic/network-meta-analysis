install.packages("netmeta")
library(netmeta)

#loading a dataset included in netmeta
data("smokingcessation", package = "netmeta")
str(smokingcessation)
head(smokingcessation)

#adding the missing column for study ID
smokingcessation$studlab <- paste0("Study_", 1:nrow(smokingcessation))
smokingcessation <- smokingcessation[, 
  c("studlab", setdiff(names(smokingcessation), "studlab"))] #placing the study ID column as first one

#conducting a pairwise meta-analysis on binary data to obtain log odds ratios and corresponding standard errors from each study
pw <- pairwise(
  treat = list(treat1, treat2, treat3),
  event = list(event1, event2, event3),
  n = list(n1, n2, n3),
  studlab = studlab,
  data = smokingcessation,
  sm = "OR"
)
head (pw)


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
netgraph(net1,multiarm=TRUE, plastic = TRUE)
netleague(net1, digits = 2)
netrank(net1, small.values = "good")
rankogram(net1, small.values="good")
forest(net1)
net1$Q
net1$df.Q
net1$tau
netsplit(net1)
netheat(net1)
netimpact(net1)
net_fixed <- update(net1, random = FALSE)
summary(net_fixed)
summary(net1)