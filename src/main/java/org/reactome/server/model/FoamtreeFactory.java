package org.reactome.server.model;

import org.reactome.server.graph.domain.model.Event;
import org.reactome.server.graph.domain.model.Pathway;
import org.reactome.server.graph.service.TopLevelPathwayService;
import org.reactome.server.model.data.Foamtree;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class FoamtreeFactory {

    private final Map<Long, Foamtree> map = new HashMap<>();
    private final List<Foamtree> foamtrees = new ArrayList<>();

    public FoamtreeFactory(TopLevelPathwayService tlpService) {
        for (Pathway pNode : tlpService.getTopLevelPathways("Homo sapiens")) {
            Foamtree gNode = getOrCreateGroup(pNode);
            foamtrees.add(gNode);
            buildBranch(pNode, gNode);
        }
    }

    public List<Foamtree> getFoamtrees() {
        return foamtrees;
    }

    private void buildBranch(Pathway pathwayNode, Foamtree graphNode) {
        for (Event event : pathwayNode.getHasEvent()) {
            if (event instanceof Pathway) {
                Pathway pNode = (Pathway) event;
                Foamtree gNode = getOrCreateGroup(pNode);
                graphNode.addGroup(gNode);
                buildBranch(pNode, gNode);
            }
        }
    }

    private Foamtree getOrCreateGroup(Pathway node) {
        Foamtree rtn = this.map.get(node.getDbId());
        if (rtn == null) {
            rtn = new Foamtree(node);
            this.map.put(node.getDbId(), rtn);
        }
        return rtn;
    }
}
