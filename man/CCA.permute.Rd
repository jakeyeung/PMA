\name{CCA.permute}
\alias{CCA.permute}
\alias{plot.CCA.permute}
\alias{print.CCA.permute}
\title{Select tuning parameters for sparse canonical correlation
  analysis using the penalized matrix decomposition.}
\description{
This function can be used to automatically select tuning parameters for
sparse CCA using the penalized matrix decompostion. For each data set x
and z, two types are possible: (1) type "standard", which does not assume any
ordering of the columns of the data set, and (2) type "ordered", which assumes that
columns of the data set are ordered and thus that corresponding
canonical vector should be both sparse and
smooth (e.g. CGH data).

For X and Z, the
samples are on the rows and the features are on the columns.

The tuning parameters are selected using a permutation scheme. For each
candidate tuning parameter value, the following is performed: 
(1) The
samples in X are randomly permuted nperms times, to obtain
matrices $X*_1,X*_2,...$.
(2) Sparse CCA is run on each permuted data set $(X*_i,Z)$ to obtain
factors $(u*_i, v*_i)$.
(3) Sparse CCA is run on the original data (X,Z) to
obtain factors u and v.
(4) Compute $c*_i=cor(X*_i u*_i,Z v*_i)$ and $c=cor(Xu,Zv)$.
(5) Use Fisher's transformation to convert these correlations into
random variables that are approximately normally distributed. Let
Fisher(c) denote the Fisher transformation of c.
(6) Compute a
z-statistic for Fisher(c), using $(Fisher(c)-mean(Fisher(c*)))/sd(Fisher(c*))$. The larger the
z-statistic, the "better" the corresponding tuning parameter value.

This function also gives the p-value for each pair of canonical variates
(u,v) resulting from a given tuning parameter value. This p-value is
computed as the fraction of $c*_i$'s that exceed c (using the notation of
the previous paragraph).

Using this function, only the first left and right canonical variates
are considered in selection of the tuning parameter.
}
\usage{
CCA.permute(x,z,typex=c("standard", "ordered"),typez=c("standard","ordered"), penaltyxs=NULL, penaltyzs=NULL,
niter=3,v=NULL,trace=TRUE,nperms=25, standardize=TRUE, chromx=NULL,
chromz=NULL,upos=FALSE, uneg=FALSE, vpos=FALSE, vneg=FALSE,outcome=NULL,
y=NULL, cens=NULL)
\method{plot}{CCA.permute}(x,...)
\method{print}{CCA.permute}(x,...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{Data matrix; samples are rows and columns are features.}
  \item{z}{Data matrix; samples are rows and columns are
      features. Note that x and z must have the same number of rows, but
      may (and generally will) have different numbers of columns.}
    \item{typex}{Are the columns of x unordered (type="standard") or
    ordered (type="ordered")? If "standard", then a lasso penalty is
    applied to v, to enforce sparsity. If "ordered"  (generally used
    for CGH data), then a fused  lasso penalty is applied, to enforce both
    sparsity and smoothness.}
    \item{typez}{Are the columns of z unordered  (type="standard") or
   ordered (type="ordered")? If "standard",   then a lasso penalty is
   applied to v, to enforce sparsity. If "ordered" (generally used
    for CGH data), then a fused lasso penalty is applied, to
    enforce both sparsity and smoothness.}
   \item{penaltyxs}{The set of x penalties to be considered. If
     typex="standard", then the L1 bound on u is penaltyxs*sqrt(ncol(x)). If "ordered",
     then it's the lambda for the fused lasso penalty. The user
     can specify a single value or a
     vector of values. If penaltyxs is a vector and penaltyzs is a
     vector, then the vectors must have the same length. If NULL, then
     the software will automatically choose a single lambda value if
     type is "ordered", or a grid of (L1 bounds)/sqrt(ncol(x)) if type is "standard".}
      \item{penaltyzs}{The set of z penalties to be considered. If
     typez="standard", then the L1 bound on v is penaltyzs*sqrt(ncol(z)). If "ordered",
     then it's the lambda for the fused lasso penalty. The user
     can specify a single value or a
     vector of values. If penaltyzs is a vector and penaltyzs is a
     vector, then the vectors must have the same length. If NULL, then
     the software will automatically choose a single lambda value if
     type is "ordered", or a grid of (L1 bounds)/sqrt(ncol(z)) if type is "standard".}
  \item{niter}{How many iterations should be performed each time CCA is
    called? Default is 3, since an approximate estimate of u and v is
    acceptable in this case, and otherwise this function can be quite time-consuming.}
  \item{v}{The first K columns of the v matrix of the SVD of X'Z. If
    NULL, then the SVD of X'Z will be computed inside this function. However, if
    you plan to run this function multiple times, then save a copy of
    this argument so that it does not need to be re-computed (since that
    process can be time-consuming if X and Z both have high dimension).}
  \item{trace}{Print out progress?}
  \item{nperms}{How many times should the data be permuted? Default is
    25. A large value of nperms is very important here, since the
    formula for computing the z-statistics requires a standard deviation
    estimate for the correlations obtained via permutation, which will
    not be accurate if nperms is very small.}
  \item{standardize}{Should the columns of X and Z be centered (to have mean
    zero)
    and scaled (to have standard deviation 1)? Default is TRUE.}
    \item{chromx}{Used only if typex="ordered"; a vector of length ncol(x)
    that allows you to specify which chromosome each CGH spot is on. If
    NULL, then it is assumed that all CGH spots are on same chromosome.}
    \item{chromz}{Used only if typex="ordered"; a vector of length ncol(z)
    that allows you to specify which chromosome each CGH spot is on. If
    NULL, then it is assumed that all CGH spots are on same chromosome.}
  \item{upos}{If TRUE, then require all elements of u to be positive in
    sign. Default is FALSE. Can only be used if type is standard.}
  \item{uneg}{If TRUE, then require all elements of u to be negative in
    sign. Default is FALSE. Can only be used if type is standard.}
  \item{vpos}{If TRUE, then require all
    elements of v to be positive in sign. Default is FALSE.  Can only be used if type is standard.}
  \item{vneg}{If TRUE, then require all
    elements of v to be negative in sign. Default is FALSE. Can only be used if type is standard.}
  \item{outcome}{If you would like to incorporate a phenotype into CCA
    analysis - that is, you wish to find features that are correlated
    across the two data sets and also correlated
    with a phenotype - then use one of "survival", "multiclass", or
    "quantitative" to indicate outcome type. Default is NULL.}
  \item{y}{If outcome is not NULL, then this is a vector of phenotypes -
    one for each row of x and z. If outcome is "survival" then these are
    survival times; must be non-negative. If outcome is "multiclass"
    then these are class labels. Default NULL.}
  \item{cens}{If outcome is "survival" then these are censoring statuses
    for each observation. 1 is complete, 0 is censored. Default NULL.}
  \item{\dots}{ not used. } 
}
\details{
  Note that x and z must have same number of rows. This function performs
 just a one-dimensional search in tuning parameter space, even if
 penaltyxs and penaltyzs both are vectors: the pairs
 (penaltyxs[1],penaltyzs[1]),(penaltyxs[2],penaltyzs[2]),.... are considered. 
}
\value{
  \item{zstat}{The vector of z-statistics, one per element of sumabss.}
  \item{pvals}{The vector of p-values, one per element of sumabss.}
 \item{bestpenaltyx}{The x penalty that
   resulted in the highest z-statistic.}
  \item{bestpenaltyz}{The z penalty that
   resulted in the highest z-statistic.}
 \item{cors}{The value of cor(Xu,Zv) obtained for each value of
    sumabss.}
  \item{corperms}{The nperms values of cor(X*u*,Zv*) obtained for
    each value of sumabss, where X* indicates  the X matrix with
    permuted rows, and u* and v* are the output of CCA using data
    (X*,Z).}
  \item{ft.cors}{The result of applying Fisher transformation to cors.}
  \item{ft.corperms}{The result of applying Fisher transformation to
    corperms.}
  \item{nnonzerous}{Number of non-zero u's resulting from applying CCA
    to data (X,Z) for each value of sumabss.}
  \item{nnonzerouv}{Number of non-zero v's resulting from applying CCA
    to data (X,Z) for each value of sumabss.}
  \item{v.init}{The first factor  of the v matrix of the SVD of
    x'z. This is saved in case this function (or the CCA function) will be re-run later.}
}
\references{Witten, DM and Tibshirani, R and T Hastie (2008) A penalized
  matrix decomposition, with applications to
  sparse principal components and canonical correlation
  analysis. Submitted. <http://www-stat.stanford.edu/~dwitten>}
\author{Daniela M. Witten, Robert Tibshirani}
\seealso{\link{PMD},\link{CCA}}
\examples{
# See examples in CCA function
}

