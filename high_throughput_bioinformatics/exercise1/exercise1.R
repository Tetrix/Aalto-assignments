heads <- seq(1, 30, by=1)
for (i in heads){
  prob_heads[i] = dbinom(i, size=30, prob=0.5)
}

plot(heads, prob_heads)


# probability of twenty or more heads
prob_heads = 1 - pbinom(19, size=30, prob=0.5)
sprintf("The probability of getting 20 or more heads is: %f", prob_heads)

