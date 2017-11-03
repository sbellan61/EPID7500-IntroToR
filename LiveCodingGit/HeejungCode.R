HRcombos <- expand.grid(HRa=0:1, HRb=0:1, HRc=0:1)
HRcombos
HRcombos <- cbind(Href=1, HRcombos )
HRcombos

literatureHazards <- matrix(c(Href = 30/10^5, HRa = 3, HRb = .7, HRc = 1.2), nrow = 1, ncol = 4)
literatureHazards
literatureHazards <- literatureHazards[rep(1,8),] ## repeat the row 8 times to make it easy to multiply these together
literatureHazards

hazMatrix <- HRcombos * literatureHazards
hazMatrix
hazMatrix[hazMatrix==0] <- 1 ## replace the 0s with 1s so we can multiply all elements in a row and have 1's in place for when we aren't mutliplying by the hazard ratio
hazMatrix

hazardsForEachGroup <- apply(hazMatrix, MARGIN = 1, FUN = prod) ## multiply all row elements together (i.e. margin =1 means do the function across the row index)
hazardsForEachGroup

