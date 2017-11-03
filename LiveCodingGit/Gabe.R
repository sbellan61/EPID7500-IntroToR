ORcombos <- expand.grid(pret=0:1, black=0:1, hispanic=0:1, age=0:1)
ORcombos
nr <- nrow(ORcombos)

literatureORs <- matrix(c(pret = 30/10^5, black = 3, hispanic = .7, age = 1.2), nrow = 1, ncol = 4)
literatureORs
literatureORs <- literatureORs[rep(1,16),] ## repeat the row 8 times to make it easy to multiply these together
literatureORs

ORMatrix <- ORcombos * literatureORs
ORMatrix
ORMatrix
ORMatrix[ORMatrix==0] <- 1 ## replace the 0s with 1s so we can multiply all elements in a row and have 1's in place for when we aren't mutliplying by the hazard ratio
ORMatrix

ORForEachGroup <- apply(ORMatrix, MARGIN = 1, FUN = prod) ## multiply all row elements together (i.e. margin =1 means do the function across the row index)
thingToLeftJoin <- as.tibble(cbind(ORcombos, ORForEachGroup))
thingToLeftJoin

