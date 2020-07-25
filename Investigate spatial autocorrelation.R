library(ecospat)

Bsal <- na.exclude(read.delim("Bsal.txt", h = T, sep = "\t", dec = ","))

# (1): Investigate spatial autocorrelation of environmental covariables within a set of occurrences as a function of distance. This is only useful to test distance-related hypotheses (e.g. are occurrence sites located close to each other more similar than those at greater distance). Can't be used to assess spatial autocorrelation of the occurrences themselves! 
Bsalpres <- Bsal[!(Bsal$Bsal==0),] # get rid of absences
Bsalxy <- Bsalpres[,-3] # drop presence-absence
# Upload prediction parameters obtained through GLM model selection;
env <- env_glm # or env_rf
Bsal_env <- extract(env, Bsalxy) # extract environment at xy
Bsal_env_df <- as.data.frame(Bsal_env)
Bsaly <- Bsalpres[,2]
Bsalx <- Bsalpres[,1]
Bsal_autocor <- cbind(Bsal_env_df, Bsalx, Bsaly) # add x and y columns
# Remove parameters that we excluded based on collinearity;
# Bsal_sample <- Bsal_sample[, -c(12:13, 23:24, 28:29)]
# Remove species;
#Bsal_sample <- Bsal_sample[, -c(5:6, 14, 22)]

# Draw a plot with distance vs. the Mantel r value. Black circles indicate that the values are significative different from zero. White circles indicate non significant autocorrelation. The selected distance is at the first white circle where values are non significative different from zero;
ecospat.mantel.correlogram (dfvar = Bsal_autocor[c(1:15)], # entire dataframe
                            colxy = 14:15, # x and y columns
                            colvar =  1:13, # predictor parameter columns
                            n = 100, #nr points randomly drawn among pres-abs
                            max = 4, # max distance (I guess in dec degree)
                            nclass = 50, # nr. distance classes
                            nperm = 1000) #nr. permutations

