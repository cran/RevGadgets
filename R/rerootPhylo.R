#' Reroot Phylo
#'
#' Reroots a phylogeny given an outgroup taxon or clade
#'
#' Modifies a tree object by rerooting using a specified
#' outgroup taxon or clade. Places the root at the midpoint
#' of the branch subtending the outgroup. If the input
#' contains multiple trees, all trees will be rerooted.
#'
#'
#' @param tree (list of lists of treedata objects; no default) Name of a list of
#' lists of treedata objects, such as produced by readTrees().
#'
#' @param outgroup (character, no default) Name of the outgroup(s). Either a
#' single taxon name or a character vector of length two to specify a clade;
#' in this case the root will be placed at the midpoint of the branch subtending
#' the two taxa's MRCA. Modified from phytools::reroot().
#'
#' @return returns a list of list of treedata objects, with the trees rooted.
#'
#' @seealso phytools: \link[phytools]{reroot}.
#'
#' @examples
#'
#' file <- system.file("extdata",
#'                     "sub_models/primates_cytb_GTR_MAP.tre",
#'                     package="RevGadgets")
#' tree <- readTrees(paths = file)
#' # root with one taxon
#' tree_rooted <- rerootPhylo(tree = tree, outgroup = "Galeopterus_variegatus")
#' # root with clade, specified by two taxa
#' tree_rooted <- rerootPhylo(tree = tree,
#'                            outgroup = c("Varecia_variegata_variegata",
#'                                         "Propithecus_coquereli"))
#'
#' @export

rerootPhylo <- function(tree, outgroup) {
  if (!is.list(tree))
    stop("tree should be a list of lists of treedata objects")
  if (!methods::is(tree[[1]][[1]], "treedata"))
    stop("tree should be a list of lists of treedata objects")
  if (!methods::is(outgroup, "character"))
    stop("outgroup should be of class character")
  if (length(outgroup) > 2)
    stop("outgroup should contain 1 or 2 taxa names")

  for (i in seq_len(length(tree))) {
    for (j in seq_len(length(tree[[i]]))) {
      # Make tips names for tree and add to data object
      node_name <- .makeNodeNames(tree = tree[[i]][[j]]@phylo)
      tree[[i]][[j]]@data <-
        tree[[i]][[j]]@data[order(as.numeric(tree[[i]][[j]]@data$node)),]
      tree[[i]][[j]]@data$node_name <- node_name$node_names

      # Check that outgroups are in tree
      for (k in seq_len(length(outgroup))) {
        if (outgroup[k] %in% tree[[i]][[j]]@phylo$tip.label == FALSE) {
          stop(
            paste0(
              "Outgroup ",
              outgroup[k],
              " not found in tree. Check spelling and underscores."
            )
          )
        }
      }

      if ( ape::is.rooted(tree[[i]][[j]]@phylo) == TRUE ) {

          # unroot then reroot the tree
          tmp <- tree[[i]][[j]]@phylo
          t_unrooted <- ape::unroot(tmp)
          if (length(outgroup) == 1) {
              num <- which(t_unrooted$tip.label == outgroup)
          } else {
              num <- ape::getMRCA(t_unrooted, outgroup)
          }
          
          midpoint <-
              0.5 * t_unrooted$edge.length[which(t_unrooted$edge[, 2] == num)]
          t_rooted <-
              phytools::reroot(t_unrooted, num, position = midpoint)
          
      } else {

          # reroot the tree
          tmp <- tree[[i]][[j]]@phylo
          t_unrooted <- tmp
          if (length(outgroup) == 1) {
              num <- which(t_unrooted$tip.label == outgroup)
          } else {
              num <- ape::getMRCA(t_unrooted, outgroup)
          }
          
          midpoint <-
              0.5 * t_unrooted$edge.length[which(t_unrooted$edge[, 2] == num)]
          t_rooted <-
              phytools::reroot(t_unrooted, num, position = midpoint)
          
          # make the new root node
          node_names_new <-
              data.frame(
                  index     = as.character(length(t_rooted$tip.label) + t_rooted$Nnode),
                  node      = as.character(length(t_rooted$tip.label) + t_rooted$Nnode),
                  node_name = utils::tail(.makeNodeNames(tree = t_rooted)$node_names, 1)
              )
          
          # add the new root node
          tree[[i]][[j]]@data <-
              dplyr::full_join(tree[[i]][[j]]@data,
                               node_names_new,
                               by = c("index", "node", "node_name"))
                    
      }
      
      # Get node names for new, rerooted tree
      node_names_bits <- .makeNodeNames(tree = t_rooted)
      node_names_new <-
        data.frame(
          node_name    = node_names_bits$node_names,
          node_name_op = node_names_bits$node_names_op,
          node_new     = 1:(length(t_rooted$tip.label) + t_rooted$Nnode)
        )

      # Combine new node names with data to associate new tree
      tree[[i]][[j]]@data <- dplyr::full_join(tree[[i]][[j]]@data, node_names_new, by = "node_name")

      # Some nodes now have no info
      # Assign them the info from nodes that contain every BUT those taxa
      for (k in 1:nrow(tree[[i]][[j]]@data)) {
        if (is.na(tree[[i]][[j]]@data$node_new[k])) {
          n <-
            which(tree[[i]][[j]]@data$node_name_op == tree[[i]][[j]]@data$node_name[k])
          tree[[i]][[j]]@data$node_new[k] <-
            tree[[i]][[j]]@data$node_new[n]
        }
      }
      
      # clear out NA rows
      tree[[i]][[j]]@data <- tree[[i]][[j]]@data[is.na(tree[[i]][[j]]@data$node) == FALSE,]
      
      # replace old node ID with new
      tree[[i]][[j]]@data$node <- NULL
      tree[[i]][[j]]@data$node <- tree[[i]][[j]]@data$node_new
      
      # replace old tree with new
      tree[[i]][[j]]@phylo <- t_rooted

    }

  }

  return(tree)
}
