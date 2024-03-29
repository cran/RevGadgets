% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rerootPhylo.R
\name{rerootPhylo}
\alias{rerootPhylo}
\title{Reroot Phylo}
\usage{
rerootPhylo(tree, outgroup)
}
\arguments{
\item{tree}{(list of lists of treedata objects; no default) Name of a list of
lists of treedata objects, such as produced by readTrees().}

\item{outgroup}{(character, no default) Name of the outgroup(s). Either a
single taxon name or a character vector of length two to specify a clade;
in this case the root will be placed at the midpoint of the branch subtending
the two taxa's MRCA. Modified from phytools::reroot().}
}
\value{
returns a list of list of treedata objects, with the trees rooted.
}
\description{
Reroots a phylogeny given an outgroup taxon or clade
}
\details{
Modifies a tree object by rerooting using a specified
outgroup taxon or clade. Places the root at the midpoint
of the branch subtending the outgroup. If the input
contains multiple trees, all trees will be rerooted.
}
\examples{

file <- system.file("extdata",
                    "sub_models/primates_cytb_GTR_MAP.tre",
                    package="RevGadgets")
tree <- readTrees(paths = file)
# root with one taxon
tree_rooted <- rerootPhylo(tree = tree, outgroup = "Galeopterus_variegatus")
# root with clade, specified by two taxa
tree_rooted <- rerootPhylo(tree = tree,
                           outgroup = c("Varecia_variegata_variegata",
                                        "Propithecus_coquereli"))

}
\seealso{
phytools: \link[phytools]{reroot}.
}
