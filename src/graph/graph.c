#include <cgraph.h>
#include <gvc.h>

#define MAXWORKERS 100

int main(int argc, char **argv)
{
    Agraph_t *g;
    Agraph_t *workers[MAXWORKERS];
    GVC_t *gvc;

    /* set up a graphviz context */
    gvc = gvContext();

    /* Create a simple digraph */
    g = agopen("g", Agdirected, NULL);
    workers[1] = agsubg(g, "cluster_1", 1);
    agnode(workers[1], "1", 1);
    agnode(workers[1], "2", 1);
    workers[2] = agsubg(g, "cluster_2", 1);
    agnode(workers[2], "3", 1);
    agnode(workers[2], "4", 1);

    /* Compute a layout */
    gvLayout(gvc, g, "dot");

    /* Write the graph */
    gvRender(gvc, g, "svg", stdout);

    /* Free layout data */
    gvFreeLayout(gvc, g);

    /* Free graph structures */
    agclose(g);

    /* close output file, free context, and return number of errors */
    return (gvFreeContext(gvc));
}
