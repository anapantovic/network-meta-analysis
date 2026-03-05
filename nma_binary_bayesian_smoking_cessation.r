#installing and loading the necessary packages
install.packages("gemtc")
library(gemtc)
install.packages("rjags")
library(rjags)
library(netmeta)

setwd ("C:/Users/Windows 10/OneDrive/Desktop/project/network-meta-analysis")
#reading the binary data dataset on smoking cessation
smokingcessation <- readRDS("smokingcessation_clean.rds")

#preparing the dataset for mtc.network function
colnames(smokingcessation) <- c("study", "responders1", "sampleSize1", "responders2", "sampleSize2", "responders3", "sampleSize3", "treatment1", "treatment2", "treatment3")

#wide to long format
library(dplyr)
install.packages("tidyr")
library(tidyr)
library(gemtc)
sc_long <- smokingcessation %>%
  pivot_longer(
    cols = matches("^(responders|sampleSize|treatment)[1-3]$"),
    names_to = c(".value", "arm"),
    names_pattern = "^(responders|sampleSize|treatment)([1-3])$"
  ) %>%
  filter(!is.na(treatment), !is.na(sampleSize)) %>%      # drop missing arms (e.g., arm3 for 2-arm trials)
  mutate(
    study = as.character(study),
    treatment = as.character(treatment)
  )
sc_long

#network setup
network_sc <- mtc.network(data.ab=sc_long, description="Bayesian NMA binary data")
plot(network_sc)
summary(network_sc)

#setting up a network model (fixed-effects vs radnom-effects)
model_nma_sc_f <- mtc.model(network_sc, linearModel= "fixed", n.chain=4)
model_nma_sc_r <- mtc.model(network_sc, linearModel= "random", n.chain=4)

#runing a Markov chain Monte Carlo on the defined fixed-effects network model
mcmc_nma_sc1 <- mtc.run(model_nma_sc_f, n.adapt=5000, n.iter=10000, thin=20)
mcmc_nma_sc2 <- mtc.run(model_nma_sc_f, n.adapt=5000, n.iter=10000, thin=10)

#runing a Markov chain Monte Carlo on the defined random-effects network model
mcmc_nma_sc3 <- mtc.run(model_nma_sc_r, n.adapt=5000, n.iter=10000, thin=20)
mcmc_nma_sc4 <- mtc.run(model_nma_sc_r, n.adapt=5000, n.iter=10000, thin=10)

#checking the convergence status of MCMC simulation of fixed and random-effects models - error, DIC
summary(mcmc_nma_sc1)
summary(mcmc_nma_sc2)
summary(mcmc_nma_sc3)
summary(mcmc_nma_sc4)
plot(mcmc_nma_sc1)
plot(mcmc_nma_sc2)
plot(mcmc_nma_sc3)
plot(mcmc_nma_sc4)
gelman.diag(mcmc_nma_sc1)
gelman.diag(mcmc_nma_sc2)
gelman.diag(mcmc_nma_sc3)
gelman.diag(mcmc_nma_sc4)
gelman.plot(mcmc_nma_sc1)
gelman.plot(mcmc_nma_sc2)
gelman.plot(mcmc_nma_sc3)
gelman.plot(mcmc_nma_sc4)

#testing consistency - more reliable results achieved for random-effects model
nodesplit_nma_sc_f <- mtc.nodesplit(network_sc, linearModel="fixed", n.adapt=5000, n.iter=10000, thin=10)
plot(nodesplit_nma_sc_f)
plot(summary(nodesplit_nma_sc_f))
summary(nodesplit_nma_sc_f)
nodesplit_nma_sc_r <- mtc.nodesplit(network_sc, linearModel="random", n.adapt=5000, n.iter=10000, thin=10)
plot(nodesplit_nma_sc_r)
plot(summary(nodesplit_nma_sc_r))
summary(nodesplit_nma_sc_r)

#producing a forest plot - mcmc_nma_sc2 for fixed and mcmc_nma_sc4 for random-effect model
forest(relative.effect(mcmc_nma_sc2, t1="A"), digits=3)
forest(relative.effect(mcmc_nma_sc4, t1="A"), digits=3)


#ranking of treatments
ranks_nma_sc_f <- rank.probability(mcmc_nma_sc2, preferredDirection=-1)
print(ranks_nma_sc_f)
ranks_nma_sc_r <- rank.probability(mcmc_nma_sc4, preferredDirection=-1)
print(ranks_nma_sc_r)



