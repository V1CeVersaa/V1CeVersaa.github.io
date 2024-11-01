# Image Classfication

## Nearest Neighbor

Distance Metric to compare images: 

- L1 distance/Manhattan distance: $\displaystyle d_1(I_1, I_2) = \sum\limits_p\lvert I_1^p - I_2^p\rvert.$

    ??? Info "Code"
        ```python
        import numpy as np

        class NearestNeighbor:
            def __init__(self):
                pass
            
            def train(self, X, y):
                """
                :param X is N * D where each row is an example.
                :param y is 1-dimension of size N
                """
                self.Xtr = X
                self.ytr = y
            
            def predict(self, X):
                """
                :param X is N * D where each row is an example we wish to predict for
                """
                num_test = X.shape[0]
                Ypred = np.zeros(num_test, dtype = self.ytr.dtype)

                for i in range(num_test):
                    distances = np.sum(np.abs(self.Xtr - X[i,:]), axis = 1)
                    min_index = np.argmin(distances)
                    Ypred[i] = self.ytr[min_index]
                
                return Ypred
        ```
    - Problems: 

K-Nearest Neighbors:

- If $k > 1$, there can be ties between classes. Need to break somehow.

Change distance metric:

- L2 distance/Euclidean distance: $\displaystyle d_2(I_1, I_2) = \sqrt{\sum\limits_p(I_1^p - I_2^p)^2}.$

With the right choice of distance metric, we can apply KNN to any type of data.

- Compare research papers using tf-idf(term frequency-inverse document frequency) similarity.
- 虽然简单，但是非常 robust. 

Hyperparameters: 

- choices about our learning algorithm that we don't learn from the training data, instead we set them at the start of the learning progress. 
- Very problem-independent. In general need to try them all and see what works best for our data and task.

Setting Hyperparameters:

- Choose hyperparameters that work best on the data: bad, because $k=1$ always works perfectly on the training data.
- Split the dataset into train and test, choose hyperparameters that work best on the test set: bad, 因为我们并不知道通过 test set 筛选出来的 hyperparameters 在新的数据中的表现，也就是被测试集污染了. 
- Split data into train, val, and test; choose hyperparameters on val and evaluate on test: good, 只有在测试的时候才会接触 test set.
- **Cross-Validation/交叉验证**: Split data into folds, try each fold as validation and average the results: Useful for small datasets, but (unfortunately) not used too frequently in deep learning. 