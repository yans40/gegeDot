import React, { useEffect, useRef, useState } from 'react';
import * as d3 from 'd3';
import { Box, Paper, Typography, IconButton, Tooltip } from '@mui/material';
import { ZoomIn, ZoomOut, Home, Download, Share } from '@mui/icons-material';

interface Person {
  id: number;
  fullName: string;
  gender: 'Male' | 'Female' | 'Other';
  isAlive: boolean;
  birthDate?: string;
  deathDate?: string;
  biography?: string;
}

interface FamilyData {
  person: Person;
  parents: Person[];
  children: Person[];
  siblings: Person[];
  spouse?: Person;
  grandparents: Person[];
  grandchildren: Person[];
  totalFamilyMembers: number;
}

interface HierarchicalNode {
  id: number;
  name: string;
  gender: 'Male' | 'Female' | 'Other';
  isAlive: boolean;
  birthDate?: string;
  deathDate?: string;
  biography?: string;
  type: 'main' | 'parent' | 'child' | 'spouse' | 'sibling' | 'grandparent' | 'grandchild';
  level: number; // Niveau hiérarchique (0 = racine, 1 = parents, 2 = grands-parents, etc.)
  siblings?: HierarchicalNode[]; // Pour grouper les frères/sœurs
  x?: number;
  y?: number;
}

interface HierarchicalLink {
  source: number;
  target: number;
  type: 'parent-child' | 'marriage' | 'sibling';
}

interface HierarchicalTreeVisualizationProps {
  familyData: FamilyData;
  layout?: 'vertical' | 'horizontal' | 'radial';
  depth?: number;
  onPersonClick?: (person: Person) => void;
}

const HierarchicalTreeVisualization: React.FC<HierarchicalTreeVisualizationProps> = ({
  familyData,
  layout = 'vertical',
  depth = 3,
  onPersonClick
}) => {
  const svgRef = useRef<SVGSVGElement>(null);
  const [zoom, setZoom] = useState(d3.zoomIdentity);
  const [tooltip, setTooltip] = useState<{ visible: boolean; content: string; x: number; y: number }>({
    visible: false,
    content: '',
    x: 0,
    y: 0
  });

  useEffect(() => {
    if (!familyData || !svgRef.current) return;

    const svg = d3.select(svgRef.current);
    const container = svg.node()?.parentElement;
    if (!container) return;

    const width = container.clientWidth;
    const height = container.clientHeight;

    // Clear previous content
    svg.selectAll('*').remove();

    // Create main group
    const g = svg.append('g');

    // Set up zoom behavior
    const zoomBehavior = d3.zoom<SVGSVGElement, unknown>()
      .scaleExtent([0.1, 4])
      .on('zoom', (event) => {
        setZoom(event.transform);
        g.attr('transform', event.transform);
      });

    svg.call(zoomBehavior);

    // Build hierarchical tree data
    const treeData = buildHierarchicalTreeData(familyData);
    const { nodes, links } = treeData;

    // Calculate positions using hierarchical layout
    const positionedNodes = calculateHierarchicalPositions(nodes, width, height);

    // Render the tree
    renderHierarchicalTree(g, positionedNodes, links, width, height);

    // Auto-center on main person
    setTimeout(() => {
      const mainNode = positionedNodes.find(n => n.type === 'main');
      if (mainNode) {
        centerOnNode(mainNode, width, height, zoomBehavior, svg);
      }
    }, 500);

  }, [familyData, layout, depth]);

  const buildHierarchicalTreeData = (data: FamilyData) => {
    const nodes: HierarchicalNode[] = [];
    const links: HierarchicalLink[] = [];

    // Add main person (level 0)
    const mainPerson: HierarchicalNode = {
      id: data.person.id,
      name: data.person.fullName,
      gender: data.person.gender,
      isAlive: data.person.isAlive,
      birthDate: data.person.birthDate,
      deathDate: data.person.deathDate,
      biography: data.person.biography,
      type: 'main',
      level: 0
    };
    nodes.push(mainPerson);

    // Add parents (level 1)
    data.parents.forEach(parent => {
      const parentNode: HierarchicalNode = {
        id: parent.id,
        name: parent.fullName,
        gender: parent.gender,
        isAlive: parent.isAlive,
        birthDate: parent.birthDate,
        deathDate: parent.deathDate,
        biography: parent.biography,
        type: 'parent',
        level: 1
      };
      nodes.push(parentNode);
      
      // Link parents to ALL children (main person + siblings)
      links.push({
        source: parent.id,
        target: data.person.id,
        type: 'parent-child'
      });
      
      // Link parents to siblings
      data.siblings.forEach(sibling => {
        links.push({
          source: parent.id,
          target: sibling.id,
          type: 'parent-child'
        });
      });
    });

    // Add siblings (level 0, same as main person)
    data.siblings.forEach(sibling => {
      const siblingNode: HierarchicalNode = {
        id: sibling.id,
        name: sibling.fullName,
        gender: sibling.gender,
        isAlive: sibling.isAlive,
        birthDate: sibling.birthDate,
        deathDate: sibling.deathDate,
        biography: sibling.biography,
        type: 'sibling',
        level: 0
      };
      nodes.push(siblingNode);
      links.push({
        source: data.person.id,
        target: sibling.id,
        type: 'sibling'
      });
    });

    // Add spouse (level 0, same as main person)
    if (data.spouse) {
      const spouseNode: HierarchicalNode = {
        id: data.spouse.id,
        name: data.spouse.fullName,
        gender: data.spouse.gender,
        isAlive: data.spouse.isAlive,
        birthDate: data.spouse.birthDate,
        deathDate: data.spouse.deathDate,
        biography: data.spouse.biography,
        type: 'spouse',
        level: 0
      };
      nodes.push(spouseNode);
      links.push({
        source: data.person.id,
        target: data.spouse.id,
        type: 'marriage'
      });
    }

    // Add children (level -1)
    data.children.forEach(child => {
      const childNode: HierarchicalNode = {
        id: child.id,
        name: child.fullName,
        gender: child.gender,
        isAlive: child.isAlive,
        birthDate: child.birthDate,
        deathDate: child.deathDate,
        biography: child.biography,
        type: 'child',
        level: -1
      };
      nodes.push(childNode);
      links.push({
        source: data.person.id,
        target: child.id,
        type: 'parent-child'
      });
    });

    // Add grandparents (level 2)
    data.grandparents.forEach(grandparent => {
      const grandparentNode: HierarchicalNode = {
        id: grandparent.id,
        name: grandparent.fullName,
        gender: grandparent.gender,
        isAlive: grandparent.isAlive,
        birthDate: grandparent.birthDate,
        deathDate: grandparent.deathDate,
        biography: grandparent.biography,
        type: 'grandparent',
        level: 2
      };
      nodes.push(grandparentNode);
      
      // Link to parents
      data.parents.forEach(parent => {
        links.push({
          source: grandparent.id,
          target: parent.id,
          type: 'parent-child'
        });
      });
    });

    // Add grandchildren (level -2)
    data.grandchildren.forEach(grandchild => {
      const grandchildNode: HierarchicalNode = {
        id: grandchild.id,
        name: grandchild.fullName,
        gender: grandchild.gender,
        isAlive: grandchild.isAlive,
        birthDate: grandchild.birthDate,
        deathDate: grandchild.deathDate,
        biography: grandchild.biography,
        type: 'grandchild',
        level: -2
      };
      nodes.push(grandchildNode);
      
      // Link to children
      data.children.forEach(child => {
        links.push({
          source: child.id,
          target: grandchild.id,
          type: 'parent-child'
        });
      });
    });

    return { nodes, links };
  };

  const calculateHierarchicalPositions = (nodes: HierarchicalNode[], width: number, height: number) => {
    const nodeWidth = 120;
    const nodeHeight = 80;
    const levelSpacing = 200;
    const siblingSpacing = 150;
    const centerX = width / 2;
    const centerY = height / 2;

    // Group nodes by level
    const nodesByLevel = new Map<number, HierarchicalNode[]>();
    nodes.forEach(node => {
      if (!nodesByLevel.has(node.level)) {
        nodesByLevel.set(node.level, []);
      }
      nodesByLevel.get(node.level)!.push(node);
    });

    // First pass: calculate positions for all levels except parents
    const sortedLevels = Array.from(nodesByLevel.keys()).sort((a, b) => a - b);
    
    sortedLevels.forEach(level => {
      if (level !== 1) { // Skip parents for now
        const levelNodes = nodesByLevel.get(level)!;
        // Level 0 (children) at centerY, level -1 (grandchildren) below, level 2 (grandparents) above
        let y;
        if (level === 2) {
          // Grandparents should be above parents (level 1 is at centerY - levelSpacing)
          y = centerY - (2 * levelSpacing);
        } else {
          y = centerY + (level * levelSpacing);
        }
        
        const totalWidth = (levelNodes.length - 1) * siblingSpacing;
        const startX = centerX - (totalWidth / 2);

        levelNodes.forEach((node, index) => {
          node.x = startX + (index * siblingSpacing);
          node.y = y;
        });
      }
    });
    
    // Second pass: calculate positions for parents (level 1) based on their children
    if (nodesByLevel.has(1)) {
      const parentNodes = nodesByLevel.get(1)!;
      // Parents should be ABOVE children, so y should be smaller (level 1 = above level 0)
      const y = centerY - levelSpacing; // Above the children
      
      // Find the main person and their siblings to center parents above them
      const mainPerson = nodes.find(n => n.type === 'main');
      const siblings = nodes.filter(n => n.type === 'sibling' && n.level === 0);
      const allLevel0Nodes = [mainPerson, ...siblings].filter(Boolean) as HierarchicalNode[];
      
      if (allLevel0Nodes.length > 0 && allLevel0Nodes.every(node => node.x !== undefined)) {
        // Calculate the center of level 0 nodes
        const level0CenterX = allLevel0Nodes.reduce((sum, node) => sum + (node.x || 0), 0) / allLevel0Nodes.length;
        
        // Position parents centered above their children
        const totalWidth = (parentNodes.length - 1) * siblingSpacing;
        const startX = level0CenterX - (totalWidth / 2);
        
        parentNodes.forEach((node, index) => {
          node.x = startX + (index * siblingSpacing);
          node.y = y;
        });
      } else {
        // Fallback to center positioning
        const totalWidth = (parentNodes.length - 1) * siblingSpacing;
        const startX = centerX - (totalWidth / 2);
        
        parentNodes.forEach((node, index) => {
          node.x = startX + (index * siblingSpacing);
          node.y = y;
        });
      }
    }

    return nodes;
  };

  const renderHierarchicalTree = (g: d3.Selection<SVGGElement, unknown, null, undefined>, nodes: HierarchicalNode[], links: HierarchicalLink[], width: number, height: number) => {
    // Create links
    const linkGroup = g.append('g').attr('class', 'links');
    
    links.forEach(link => {
      const sourceNode = nodes.find(n => n.id === link.source);
      const targetNode = nodes.find(n => n.id === link.target);
      
      if (sourceNode && targetNode && sourceNode.x !== undefined && sourceNode.y !== undefined && targetNode.x !== undefined && targetNode.y !== undefined) {
        const linkElement = linkGroup.append('line')
          .attr('x1', sourceNode.x)
          .attr('y1', sourceNode.y)
          .attr('x2', targetNode.x)
          .attr('y2', targetNode.y)
          .attr('class', `link ${link.type}`)
          .style('stroke', getLinkColor(link.type))
          .style('stroke-width', getLinkWidth(link.type))
          .style('stroke-dasharray', getLinkDashArray(link.type));
      }
    });

    // Create nodes
    const nodeGroup = g.append('g').attr('class', 'nodes');
    
    nodes.forEach(node => {
      if (node.x !== undefined && node.y !== undefined) {
        const nodeElement = nodeGroup.append('g')
          .attr('class', `node ${node.type}`)
          .attr('transform', `translate(${node.x}, ${node.y})`)
          .style('cursor', 'pointer');

        // Node circle
        nodeElement.append('circle')
          .attr('r', getNodeRadius(node.type))
          .style('fill', getNodeColor(node.gender, node.isAlive))
          .style('stroke', getNodeStroke(node.type))
          .style('stroke-width', getNodeStrokeWidth(node.type));

        // Node text
        nodeElement.append('text')
          .attr('text-anchor', 'middle')
          .attr('dy', getTextOffset(node.type))
          .style('font-size', getTextSize(node.type))
          .style('font-weight', node.type === 'main' ? 'bold' : 'normal')
          .style('fill', '#333')
          .text(node.name);

        // Add click handler
        nodeElement.on('click', () => {
          if (onPersonClick) {
            const person: Person = {
              id: node.id,
              fullName: node.name,
              gender: node.gender,
              isAlive: node.isAlive,
              birthDate: node.birthDate,
              deathDate: node.deathDate,
              biography: node.biography
            };
            onPersonClick(person);
          }
        });

        // Add tooltip
        nodeElement.on('mouseover', (event) => {
          const tooltipContent = `${node.name}\n${node.gender} • ${node.isAlive ? 'Vivant' : 'Décédé'}\n${node.birthDate ? `Né: ${node.birthDate}` : ''}\n${node.deathDate ? `Décédé: ${node.deathDate}` : ''}`;
          setTooltip({
            visible: true,
            content: tooltipContent,
            x: event.pageX,
            y: event.pageY
          });
        });

        nodeElement.on('mouseout', () => {
          setTooltip({ visible: false, content: '', x: 0, y: 0 });
        });
      }
    });
  };

  // Helper functions for styling
  const getNodeRadius = (type: string) => {
    switch (type) {
      case 'main': return 25;
      case 'parent': return 20;
      case 'child': return 18;
      case 'spouse': return 22;
      case 'sibling': return 20;
      case 'grandparent': return 18;
      case 'grandchild': return 16;
      default: return 20;
    }
  };

  const getNodeColor = (gender: string, isAlive: boolean) => {
    if (!isAlive) return '#ccc';
    switch (gender) {
      case 'Male': return '#4A90E2';
      case 'Female': return '#E24A90';
      default: return '#90E24A';
    }
  };

  const getNodeStroke = (type: string) => {
    return type === 'main' ? '#FFD700' : '#333';
  };

  const getNodeStrokeWidth = (type: string) => {
    return type === 'main' ? 3 : 2;
  };

  const getTextSize = (type: string) => {
    switch (type) {
      case 'main': return '12px';
      case 'parent': return '11px';
      case 'child': return '10px';
      case 'spouse': return '11px';
      case 'sibling': return '11px';
      case 'grandparent': return '10px';
      case 'grandchild': return '9px';
      default: return '11px';
    }
  };

  const getTextOffset = (type: string) => {
    switch (type) {
      case 'main': return '35px';
      case 'parent': return '30px';
      case 'child': return '28px';
      case 'spouse': return '32px';
      case 'sibling': return '30px';
      case 'grandparent': return '28px';
      case 'grandchild': return '26px';
      default: return '30px';
    }
  };

  const getLinkColor = (type: string) => {
    switch (type) {
      case 'parent-child': return '#666';
      case 'marriage': return '#E24A90';
      case 'sibling': return '#4A90E2';
      default: return '#666';
    }
  };

  const getLinkWidth = (type: string) => {
    switch (type) {
      case 'parent-child': return 2;
      case 'marriage': return 3;
      case 'sibling': return 2;
      default: return 2;
    }
  };

  const getLinkDashArray = (type: string) => {
    switch (type) {
      case 'parent-child': return 'none';
      case 'marriage': return '5,5';
      case 'sibling': return 'none';
      default: return 'none';
    }
  };

  const centerOnNode = (node: HierarchicalNode, width: number, height: number, zoomBehavior: any, svg: any) => {
    if (node.x !== undefined && node.y !== undefined) {
      const scale = 1.5;
      const translateX = width / 2 - node.x * scale;
      const translateY = height / 2 - node.y * scale;
      
      const transform = d3.zoomIdentity.translate(translateX, translateY).scale(scale);
      svg.transition().duration(750).call(zoomBehavior.transform, transform);
    }
  };

  const handleZoomIn = () => {
    const svg = d3.select(svgRef.current);
    svg.transition().duration(300).call(
      d3.zoom<SVGSVGElement, unknown>().transform,
      d3.zoomIdentity.scale(zoom.k * 1.5)
    );
  };

  const handleZoomOut = () => {
    const svg = d3.select(svgRef.current);
    svg.transition().duration(300).call(
      d3.zoom<SVGSVGElement, unknown>().transform,
      d3.zoomIdentity.scale(zoom.k * 0.75)
    );
  };

  const handleReset = () => {
    const svg = d3.select(svgRef.current);
    svg.transition().duration(750).call(
      d3.zoom<SVGSVGElement, unknown>().transform,
      d3.zoomIdentity
    );
  };

  const handleCenterOnMain = () => {
    const svg = d3.select(svgRef.current);
    const container = svg.node()?.parentElement;
    if (!container) return;

    const width = container.clientWidth;
    const height = container.clientHeight;
    const zoomBehavior = d3.zoom<SVGSVGElement, unknown>();

    // Find main person and center on them
    const mainPerson = familyData.person;
    // This would need to be implemented based on the current node positions
    // For now, just reset the view
    handleReset();
  };

  return (
    <Box sx={{ position: 'relative', width: '100%', height: '100%' }}>
      {/* Controls */}
      <Box sx={{ position: 'absolute', top: 10, right: 10, zIndex: 1000, display: 'flex', gap: 1 }}>
        <Tooltip title="Zoom avant">
          <IconButton onClick={handleZoomIn} size="small" sx={{ bgcolor: 'white', boxShadow: 1 }}>
            <ZoomIn />
          </IconButton>
        </Tooltip>
        <Tooltip title="Zoom arrière">
          <IconButton onClick={handleZoomOut} size="small" sx={{ bgcolor: 'white', boxShadow: 1 }}>
            <ZoomOut />
          </IconButton>
        </Tooltip>
        <Tooltip title="Réinitialiser">
          <IconButton onClick={handleReset} size="small" sx={{ bgcolor: 'white', boxShadow: 1 }}>
            <Home />
          </IconButton>
        </Tooltip>
        <Tooltip title="Centrer sur la personne principale">
          <IconButton onClick={handleCenterOnMain} size="small" sx={{ bgcolor: 'white', boxShadow: 1 }}>
            <Share />
          </IconButton>
        </Tooltip>
      </Box>

      {/* Legend */}
      <Box sx={{ position: 'absolute', top: 10, left: 10, zIndex: 1000, bgcolor: 'white', p: 2, borderRadius: 1, boxShadow: 1 }}>
        <Typography variant="subtitle2" gutterBottom>
          Légende
        </Typography>
        <Box sx={{ display: 'flex', flexDirection: 'column', gap: 0.5 }}>
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
            <Box sx={{ width: 12, height: 12, borderRadius: '50%', bgcolor: '#4A90E2' }} />
            <Typography variant="caption">Homme</Typography>
          </Box>
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
            <Box sx={{ width: 12, height: 12, borderRadius: '50%', bgcolor: '#E24A90' }} />
            <Typography variant="caption">Femme</Typography>
          </Box>
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
            <Box sx={{ width: 12, height: 12, borderRadius: '50%', bgcolor: '#90E24A' }} />
            <Typography variant="caption">Autre</Typography>
          </Box>
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
            <Box sx={{ width: 12, height: 12, borderRadius: '50%', bgcolor: '#ccc' }} />
            <Typography variant="caption">Décédé</Typography>
          </Box>
        </Box>
        <Typography variant="subtitle2" sx={{ mt: 1 }} gutterBottom>
          Relations
        </Typography>
        <Box sx={{ display: 'flex', flexDirection: 'column', gap: 0.5 }}>
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
            <Box sx={{ width: 20, height: 2, bgcolor: '#666' }} />
            <Typography variant="caption">Parent-Enfant</Typography>
          </Box>
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
            <Box sx={{ width: 20, height: 2, bgcolor: '#E24A90' }} />
            <Typography variant="caption">Mariage</Typography>
          </Box>
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
            <Box sx={{ width: 20, height: 2, bgcolor: '#4A90E2' }} />
            <Typography variant="caption">Frères/Sœurs</Typography>
          </Box>
        </Box>
      </Box>

      {/* SVG */}
      <svg
        ref={svgRef}
        width="100%"
        height="100%"
        style={{ cursor: 'grab' }}
      />

      {/* Tooltip */}
      {tooltip.visible && (
        <Box
          sx={{
            position: 'fixed',
            left: tooltip.x + 10,
            top: tooltip.y - 10,
            bgcolor: 'rgba(0, 0, 0, 0.8)',
            color: 'white',
            p: 1,
            borderRadius: 1,
            fontSize: '12px',
            whiteSpace: 'pre-line',
            zIndex: 10000,
            pointerEvents: 'none'
          }}
        >
          {tooltip.content}
        </Box>
      )}
    </Box>
  );
};

export default HierarchicalTreeVisualization;
