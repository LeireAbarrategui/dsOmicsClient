##' Performing differential expression analysis using limma 
##' 
##' The function  ...
##' Outputs a matrix containing ...
##' @title Differential expression using limma
##' @param model formula indicating the condition (left side) and other covariates to be adjusted for 
##' (i.e. condition ~ covar1 + ... + covar2). The fitted model is: feature ~ condition + covar1 + ... + covarN
##' @param Set name of the DataSHIELD object to which the ExpresionSet or RangedSummarizedExperiment has been assigned
##' @param type.data optional parameter that allows the user to specify the number of CPU cores to use during 
##' @param sva logical value 
##' @param annotCols ...
##' @param datasources ....
##' 
##' @export
##' @examples
##' 

ds.limma <- function(model, Set, type.data="microarray",
                     contrasts = NULL, levels = "design", coef = 2,
                     sva=FALSE, annotCols=NULL, 
                     datasources=NULL){
  
  type <- charmatch(type.data, c("microarray", "RNAseq"))
  if(is.na(type))
    stop("type.data must be 'microarray' or 'RNAseq'")
  
  if (is.null(datasources)) {
    datasources <- DSI::datashield.connections_find()
  }
  
  if(is.null(model)){
    stop(" Please provide a valid model formula", call.=FALSE)
  }
  
  mt <- all.vars(model)
  variable_names <- mt[1] 
  if (length(mt)>1)
    covariable_names <- paste(mt[-1], collapse=",")
  else
    covariable_names <- NULL
  
  if (!is.null(annotCols)){
    annotCols <- paste(annotCols, collapse=",")
  }
 
  if (levels[1] != "design")
    {
    levels <- paste(levels, collapse=",")
  }
  if (!is.null(contrasts))
  {
    contrasts<-paste(contrasts, collapse=",")  
  }
    

  
  calltext <- call("limmaDS", Set, variable_names,
                   covariable_names, type, contrasts,
                   levels,coef, sva, annotCols)
  output <- datashield.aggregate(datasources, calltext)
  return(output)
  
}
