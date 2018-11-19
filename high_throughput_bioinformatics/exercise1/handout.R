#Set the working directory 
setwd("//home.org.aalto.fi/hallav1/data/Documents")

#The current working directory can be checked with command
getwd()

# 1.1 Installing packages in Aalto computer system
install.packages("MASS")

# 2 Hands-on exercises
print("Hello, World! :)")

# Random samples from normal distribution and a histogram:
set.seed(123) # set random seed
random.data <- rnorm(1000,mean=0,sd=1)

# Plot historam of the data
hist(random.data)

# Define title and axes:
hist(random.data,main="Random histogram",xlab="X values",ylab="Count")

# Example data set
# Investigate example data:
# Look at the data
iris
dim(iris)
dimnames(iris)
summary(iris)

# Boxplot of the first four columns.
# Boxplot
boxplot(iris[,1:4])

# Compare sepal length between two flower species with t-test:
setosaRows = (iris[,"Species"]=="setosa")
virginicaRows = (iris[,"Species"]=="virginica")
x = iris[setosaRows,"Sepal.Length"]
y = iris[virginicaRows,"Sepal.Length"]
t.test(x,y)

# Principal component analysis (PCA)
# Investigate variable contents with 'names', call subvariables with '$' or '@':
# Principal components analysis
iris.pca <- prcomp(iris[,1:4])
names(iris.pca) # check result contents

# Plot variance along each principal component
barplot(iris.pca$sdev)
# Plot first principal component
barplot(iris.pca$rotation[,"PC1"],main="PCA")
# Plot data for two random features, and then along the most important principal components:
par(mfrow=c(2,1))
plot(iris[, 1:2], main="Two of the original features")
plot(iris.pca$x[, 1:2], main="Two PCA features")

# Plots with different colors
par(mfrow=c(2,1))
plot(iris[iris[,"Species"] == "setosa",1:2],col="red",xlim=range(iris[,1]),ylim=range(iris[,2]))
points(iris[iris[,"Species"] == "virginica",1:2],col="blue")

plot(iris.pca$x[which(iris[,"Species"]=="setosa"),1:2], main="Two PCA features", col="red",xlim=range(iris.pca$x[,1]),ylim=range(iris.pca$x[,2]))
points(iris.pca$x[which(iris[,"Species"]=="virginica"),1:2],col="blue")

# Order and plot correlations between 20 random samples using first 4 features:
random.samples <- sample(nrow(iris),)
flower.correlations <- cor(t(iris[random.samples,1:4]))
heatmap(flower.correlations, scale = "none")

# Produce PDF
# This will save 'myFigure.pdf' in your working directory (check with 'getwd()')
pdf("myFigure.pdf")
heatmap(flower.correlations, scale="none", col = grey(seq(0,1,length=100)))
dev.off()

# K-means
# Based on the plot it seems that there are two groups of flowers. Use K-means to detect these clusters.
# It turns out that the clusters are explainable by ower species:
km <- kmeans(iris[random.samples,1:4], centers = 2)
names(km)
iris[names(which(km$cluster == 1)),"Species"]
iris[names(which(km$cluster == 2)),"Species"]

# Hierarchical clustering
d <- dist(iris[,1:4]) # distance matrix
hc <- hclust(d, method = "ave") # hierarchical clustering
plot(hc, hang = -1) # plot







