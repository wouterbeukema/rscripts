# Create a leave-one-out datasplittable for model evaluation. Ideally, one would evaluate a model with an independent dataset. As this is usually not possible when doing invasive species distribution modelling, a part of the dataset can be reserved for model testing. One recommended approach when working with species characterised by few (<25) occurrence records is leave-one-out crossvalidation (also known as the n-1 jackknife method). In this type of k-fold cross-validation the number of bins (k) is equal to the number of occurrence localities (n) in the dataset (https://doi.org/10.1111/2041-210X.12261 and refs therein). Evaluation metrics are then summarized across these iterations. Within a biomod2 occurrence dataset, one cannot just leave 'one' out, as a presence AND an absence are needed to fit a model (http://r-forge.wu.ac.at/forum/forum.php?max_rows=50&style=nested&offset=363&forum_id=995&group_id=302). So, the number of k has to be equal to the lowest presence or absence amount.


DataSplitTable <- BIOMOD_cv(myBiomodData_rf, # can use both GLM or RF input
                            stratified.cv = FALSE, # no stratified validation
                            k = 47, # nr. of partitions equal to nr. pres abs
                            repetition = 1, # no repetitions
                            do.full.models = FALSE) # No final inclusive model
# Check if each run has at least two 'FALSE' (these are the single included absence and presence);
DataSplitTable 

# Add the Bsal xy coordinates to this table to manually remove spatially autocorrelated coordinates within a buffer in ArcGIS;
DataSplitTable <- cbind(X = Bsal$x, DataSplitTable)
DataSplitTable <- cbind(Y = Bsal$y, DataSplitTable)

write.csv(DataSplitTable, file = "DataSplitTable.csv")




