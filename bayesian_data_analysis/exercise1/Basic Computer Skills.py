
# coding: utf-8

# In[268]:


import numpy as np
from scipy.stats import beta

import matplotlib
import matplotlib.pyplot as plt


# In[269]:


mean = 0.2
variance = 0.01

def calc_alfa(mean, variance):
    return mean * (mean * (1 - mean) / variance - 1)

a = calc_alfa(mean, variance)

def calc_beta(mean, a):
    return a * (1 - mean) / mean

b = calc_beta(mean, a)

x = np.linspace(beta.ppf(0.01, a, b), beta.ppf(0.99, a, b), num=10000)
y = beta.pdf(x, a, b)

plt.plot(x, y)
plt.show()


# In[270]:


sample = beta.rvs(a, b, size = 1000)
plt.plot(x, y)
plt.hist(sample, density=True, bins = 25)
plt.show()


# In[271]:


# Calculate the mean and variance of the sample data
sample_mean = np.mean(sample)
sample_variance = np.var(sample)

print('The sample mean is: {0} . The sample variance is: {1}'.format(sample_mean, sample_variance))


# In[272]:


# Compare the mean and the sample mean
mean_plot = plt.bar([0, 1], [mean, sample_mean], 0.2,
                 color='b',
                 label='mean')

plt.xlabel('Mean')
plt.ylabel('Value')
plt.title('Difference between mean and sample mean')
plt.xticks([0, 1], ('mean', 'sample_mean'))

plt.show()


# In[273]:


# Compare the variance and the sample variance
mean_plot = plt.bar([0, 1], [variance, sample_variance], 0.2,
                 color='g',
                 label='Variance')

plt.xlabel('Variance')
plt.ylabel('Value')
plt.title('Difference between variance and sample variance')
plt.xticks([0, 1], ('variance', 'sample_variance'))

plt.show()


# In[274]:


confidence = np.percentile(sample, 95)
print('The central 95% interval of the sample distribution is: {0}'.format(confidence))

