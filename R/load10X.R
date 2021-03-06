#' Load a collection of 10X data-sets
#'
#' Loads unfiltered 10X data from each data-set and identifies which droplets are cells using the cellranger defaults.
#'
#' @export
#' @param dataDirs Vector of top level cellranger output directories (the directory that contains the "raw_gene_bc_matrices" folder).
#' @param channelNames To make droplet barcodes unique across experiment, each channel needs its own unique label.  If not given, this is set numerically.
#' @param ... Extra parameters passed to \code{SoupChannel} construction function.
#' @return A SoupChannelList object containing the count tables for each 10X dataset.
#' @seealso SoupChannel SoupChannelList estimateSoup
#' @importFrom Seurat Read10X
load10X = function(dataDirs,channelNames=NULL,...){
  if(is.null(channelNames))
    channelNames = sprintf('Channel%d',seq_along(dataDirs))
  channels = list()
  for(i in seq_along(dataDirs)){
    message(sprintf("Loading data for 10X channel %s from %s",channelNames[i],dataDirs[i]))
    dataDir = dataDirs[i]
    #Get reference
    ref = list.files(file.path(dataDir,'raw_gene_bc_matrices'))
    #Load the 10X data
    tod = Read10X(file.path(dataDir,'raw_gene_bc_matrices',ref))
    #Get the barcodes that cell ranger considers to contain cells
    cells = read.delim(file.path(dataDir,'filtered_gene_bc_matrices',ref,'barcodes.tsv'),sep='\t',header=FALSE)
    cells = gsub('-1','',cells[,1])
    #Get the index in the big table
    cellIdxs = match(cells,colnames(tod))
    channels[[channelNames[i]]] = SoupChannel(tod,tod[,cellIdxs,drop=FALSE],channelName=channelNames[i],ref=ref,path=dataDir,dataType='10X',...)
  }
  channels = SoupChannelList(channels)
  return(channels)
}

#' Load a collection of 10X data-sets
#'
#' Loads unfiltered 10X data from each data-set and identifies which droplets are cells using the cellranger defaults.
#'
#' @export
#' @importFrom Seurat Read10X_h5
load10XH5 = function(h5Files, channelNames=NULL, callCellMode="loose", ...){
  if(is.null(channelNames))
    channelNames <- sprintf('Channel%d',seq_along(h5Files))
  channels <- list()
  for(i in seq_along(h5Files)){
    message(sprintf("Loading data for 10X channel %s from %s",channelNames[i], h5Files[i]))
    h5File <- h5Files[i]
    #Load unfiltered matrix using DropletUtils
    tod <- Read10X_h5(h5File)
    is.cell <- emptyDrops(tod)$FDR <= 0.05
    if(callCellMode=="loose"){
      is.cell[is.na(is.cell)] <- FALSE
      toc <- tod[, is.cell, drop=FALSE]
    }
    if(callCellMode=="strict"){
      tod <- tod[, !is.na(is.cell), drop=FALSE]
      is.cell <- is.cell[!is.na(is.cell), drop=FALSE]
      toc <- tod[, is.cell, drop=FALSE]
    }
    channels[[channelNames[i]]] <- SoupChannel(tod, toc, channelName=channelNames[i], path=h5File, dataType='10X',...)
  }
  SoupChannelList(channels)
}