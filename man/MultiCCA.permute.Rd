\name{MultiCCA.permute}
\alias{MultiCCA.permute}
\alias{print.MultiCCA.permute}
\alias{plot.MultiCCA.permute}
\title{Select tuning parameters for sparse multiple canonical correlation
  analysis using the penalized matrix decomposition.}
\description{
This function can be used to automatically select tuning parameters for
sparse multiple CCA. This is the analog of sparse CCA, when >2 data sets
are available. Each data set may have features of type="standard"
or type="ordered" (e.g. CGH data). Assume that there are K data sets,
called $X1,...,XK$.



The tuning parameters are selected using a permutation scheme. For each
candidate tuning parameter value, the following is performed:
(1) Repeat the following n times, for n large:
(a) The
samples in $(X1,...,XK)$ are randomly permuted to obtain data sets $(X1*,...,XK*)$.
(b) Sparse multiple CCA is run on the permuted data sets $(X1*,...,XK*)$
to get canonical variates $(w1*,...,wK*)$.
(c) Record $t* = sum_(i<j) Cor(Xi* wi*, Xj* wj*)$.
(2) Sparse CCA is run on the original data $(X1,...,XK)$ to
obtain canonical variates $(w1,...,wK)$.
(3) Record $t = sum_(i<j) Cor(Xi wi, Xj wj)$.
(4) The resulting p-value is given by $mean(t* > t)$; that is, the
fraction of permuted totals that exceed the total on the real data.
Then, choose the tuning parameter value that gives the smallest value in
Step 4.



This function only selets tuning parameters for the FIRST sparse multiple CCA factors.
}
\usage{
MultiCCA.permute(xlist, penalties, ws=NULL,
type="standard", nperms=10, niter=3, trace=TRUE, standardize=TRUE)
\method{print}{MultiCCA.permute}(x,...)
\method{plot}{MultiCCA.permute}(x,...)
}
\arguments{
 \item{xlist}{A list of length K, where K is the number of data sets on
   which to perform sparse multiple CCA. Data set k should be a matrix
   of dimension $n x p_k$ where $p_k$ is the number of features in data set
   k.}
 \item{penalties}{The penalty terms to be considered in the
   cross-validation. If the same penalty term is desired for each data
   set, then this should be a vector of length equal to the number of
   penalty terms to be considered. If different penalty terms are
   desired for each data set, then this should be a matrix with rows equal
 to the number of data sets, and columns equal to the number of penalty
 terms to be considered. For a given data set Xk, if type is "standard"
 then the penalty term should be a number between 1 and $sqrt(p_k)$  (the
 number of features in data set k); it is a L1 bound on wk. If type is "ordered", on the other hand, the penalty
 term is of the form lambda in the fused lasso penalty. Therefore, the
 interpretation of the argument depends on whether type is "ordered"
or "standard" for this data set.}
    \item{type}{A K-vector containing elements "standard" or "ordered" -
      or a single value. If a single value, then it is assumed that all
      elements are the same (either "standard" or "ordered").  If columns of v are
      ordered (e.g. CGH spots ordered along the chromosome) then
      "ordered", otherwise use "standard". "standard" will result in a
      lasso ($L_1$) penalty on v, which will result in
      smoothness. "ordered" will result in a fused lasso penalty on v,
      yielding both sparsity and smoothness.}
  \item{niter}{How many iterations should be performed each time CCA is
    called? Default is 3, since an approximate estimate of u and v is
    acceptable in this case, and otherwise this function can be quite time-consuming.}
  \item{ws}{A list of length K; the kth element contanis the first ncomponents columns of the v matrix of the SVD of Xk. If
    NULL, then the SVD of Xk  will be computed inside this function. However, if
    you plan to run this function multiple times, then save a copy of
    this argument so that it does not need to be re-computed.}
  \item{trace}{Print out progress?}
  \item{nperms}{How many times should the data be permuted? Default is
    25. A large value of nperms is very important here, since the
    formula for computing the z-statistics requires a standard deviation
    estimate for the correlations obtained via permutation, which will
    not be accurate if nperms is very small.}
  \item{standardize}{Should the columns of X and Z be centered (to have
    mean zero)
    and scaled (to have standard deviation 1)? Default is TRUE.}
  \item{x}{ not used. }
  \item{\dots}{ not used. } 
}
\details{
  Note that $x1,...,xK$  must have same number of rows. This function performs
 just a one-dimensional search in tuning parameter space.
}
\value{
  \item{zstat}{The vector of z-statistics, one per element of penalties.}
  \item{pvals}{The vector of p-values, one per element of penalties.}
\item{bestpenalties}{The best set of penalties
(the one with the highest zstat).}
 \item{cors}{The value of $sum_(j<k) cor(Xk wk, Xj wj)$ obtained for each value of
    penalties.}
  \item{corperms}{The nperms values of $sum_(j<k) cor(Xk* wk*, Xj* wj*)$ obtained for
    each value of penalties, where Xk* indicates  the Xk matrix with
    permuted rows, and wk* is the canonical variate corresponding to the
permuted data.}
\item{ws.init}{Initial values used for ws in sparse multiple CCA algorithm.}

}
\references{Witten, DM and Tibshirani, R and T Hastie (2008) A penalized
  matrix decomposition, with applications to
  sparse principal components and canonical correlation
  analysis. Submitted. <http://www-stat.stanford.edu/~dwitten>}
\author{Daniela M. Witten, Robert Tibshirani}
\seealso{\link{MultiCCA}, \link{CCA.permute}, \link{CCA}}
\examples{
# See examples in MultiCCA function
}

