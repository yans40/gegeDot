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

interface TreeNode {
  id: number;
  name: string;
  gender: 'Male' | 'Female' | 'Other';
  isAlive: boolean;
  birthDate?: string;
  deathDate?: string;
  biography?: string;
  type: 'main' | 'parent' | 'child' | 'spouse' | 'sibling' | 'grandparent' | 'grandchild';
  children?: TreeNode[];
}

interface TreeLink {
  source: number;
  target: number;
  type: 'parent-child' | 'marriage' | 'sibling';
}

interface TreeVisualizationProps {
  familyData: FamilyData;
  layout?: 'vertical' | 'horizontal' | 'radial';
  depth?: number;
  onPersonClick?: (person: Person) => void;
}

const TreeVisualization: React.FC<TreeVisualizationProps> = ({
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

    // Build tree data
    const treeData = buildTreeData(familyData);
    const { nodes, links } = treeData;

    // Create tree layout
    let tree;
    switch (layout) {
      case 'horizontal':
        tree = d3.tree<TreeNode>().size([height - 100, width - 200]);
        break;
      case 'radial':
        tree = d3.tree<TreeNode>().size([2 * Math.PI, Math.min(width, height) / 2 - 50]);
        break;
      default: // vertical
        tree = d3.tree<TreeNode>().size([width - 200, height - 100]);
    }

    // Create hierarchy
    const root = d3.hierarchy<TreeNode>({ children: nodes } as any);
    tree(root);

    // Render links
    const link = g.selectAll('.link')
      .data(root.links())
      .enter().append('path')
      .attr('class', (d: any) => `link ${d.data.type || 'parent-child'}`)
      .attr('d', layout === 'radial' ? d3.linkRadial() : d3.linkHorizontal())
      .style('fill', 'none')
      .style('stroke', (d: any) => {
        switch (d.data.type) {
          case 'marriage': return '#E24A90';
          case 'parent-child': return '#4A90E2';
          case 'sibling': return '#9B59B6';
          default: return '#999';
        }
      })
      .style('stroke-width', (d: any) => d.data.type === 'marriage' ? 3 : 2)
      .style('stroke-dasharray', (d: any) => d.data.type === 'marriage' ? '5,5' : 'none');

    // Render nodes
    const node = g.selectAll('.node')
      .data(root.descendants())
      .enter().append('g')
      .attr('class', (d: any) => `node ${d.data.gender?.toLowerCase() || 'other'} ${!d.data.isAlive ? 'deceased' : ''}`)
      .attr('transform', (d: any) => {
        if (layout === 'radial') {
          return `translate(${d.y * Math.cos(d.x - Math.PI / 2)},${d.y * Math.sin(d.x - Math.PI / 2)})`;
        } else if (layout === 'horizontal') {
          return `translate(${d.y},${d.x})`;
        } else {
          return `translate(${d.x},${d.y})`;
        }
      })
      .style('cursor', 'pointer')
      .on('click', (event, d: any) => {
        if (onPersonClick) {
          onPersonClick(d.data);
        }
        // Center on clicked node
        const transform = d3.zoomTransform(svg.node()!);
        svg.transition().duration(750).call(
          zoomBehavior.transform,
          d3.zoomIdentity.translate(
            width / 2 - d.x * transform.k,
            height / 2 - d.y * transform.k
          ).scale(transform.k)
        );
      });

    // Add circles
    node.append('circle')
      .attr('r', 20)
      .style('fill', (d: any) => {
        switch (d.data.gender) {
          case 'Male': return '#4A90E2';
          case 'Female': return '#E24A90';
          default: return '#9B59B6';
        }
      })
      .style('stroke', '#fff')
      .style('stroke-width', 3)
      .style('opacity', (d: any) => d.data.isAlive ? 1 : 0.7)
      .style('stroke-dasharray', (d: any) => !d.data.isAlive ? '5,5' : 'none');

    // Add text
    node.append('text')
      .attr('dy', 35)
      .text((d: any) => d.data.name)
      .style('font-family', 'Segoe UI, sans-serif')
      .style('font-size', '12px')
      .style('font-weight', 'bold')
      .style('text-anchor', 'middle')
      .style('dominant-baseline', 'middle')
      .style('fill', '#333')
      .style('text-shadow', '1px 1px 2px rgba(255,255,255,0.8)');

    // Add tooltips
    node.on('mouseover', function(event, d: any) {
      const content = `
        <h3>${d.data.name}</h3>
        <p><strong>Genre:</strong> ${d.data.gender || 'Non spécifié'}</p>
        <p><strong>Né(e):</strong> ${d.data.birthDate ? new Date(d.data.birthDate).toLocaleDateString() : 'Non spécifié'}</p>
        ${d.data.deathDate ? `<p><strong>Décédé(e):</strong> ${new Date(d.data.deathDate).toLocaleDateString()}</p>` : ''}
        <p><strong>Statut:</strong> ${d.data.isAlive ? 'Vivant(e)' : 'Décédé(e)'}</p>
        ${d.data.biography ? `<p><strong>Biographie:</strong> ${d.data.biography.substring(0, 100)}...</p>` : ''}
      `;
      setTooltip({
        visible: true,
        content,
        x: event.pageX + 10,
        y: event.pageY - 10
      });
    })
    .on('mouseout', function() {
      setTooltip({ visible: false, content: '', x: 0, y: 0 });
    });

    // Center the tree
    const bounds = g.node()?.getBBox();
    if (bounds) {
      const widthScale = width / bounds.width;
      const heightScale = height / bounds.height;
      const scale = Math.min(widthScale, heightScale) * 0.8;
      
      g.attr('transform', `translate(${(width - bounds.width * scale) / 2},${(height - bounds.height * scale) / 2}) scale(${scale})`);
    }

  }, [familyData, layout, depth, onPersonClick]);

  const buildTreeData = (familyData: FamilyData): { nodes: TreeNode[]; links: TreeLink[] } => {
    const nodes: TreeNode[] = [];
    const links: TreeLink[] = [];

    // Add the main person
    nodes.push({
      id: familyData.person.id,
      name: familyData.person.fullName,
      gender: familyData.person.gender,
      isAlive: familyData.person.isAlive,
      birthDate: familyData.person.birthDate,
      deathDate: familyData.person.deathDate,
      biography: familyData.person.biography,
      type: 'main'
    });

    // Add parents
    familyData.parents?.forEach(parent => {
      nodes.push({
        id: parent.id,
        name: parent.fullName,
        gender: parent.gender,
        isAlive: parent.isAlive,
        birthDate: parent.birthDate,
        deathDate: parent.deathDate,
        biography: parent.biography,
        type: 'parent'
      });
      links.push({
        source: parent.id,
        target: familyData.person.id,
        type: 'parent-child'
      });
    });

    // Add children
    familyData.children?.forEach(child => {
      nodes.push({
        id: child.id,
        name: child.fullName,
        gender: child.gender,
        isAlive: child.isAlive,
        birthDate: child.birthDate,
        deathDate: child.deathDate,
        biography: child.biography,
        type: 'child'
      });
      links.push({
        source: familyData.person.id,
        target: child.id,
        type: 'parent-child'
      });
    });

    // Add spouse
    if (familyData.spouse) {
      nodes.push({
        id: familyData.spouse.id,
        name: familyData.spouse.fullName,
        gender: familyData.spouse.gender,
        isAlive: familyData.spouse.isAlive,
        birthDate: familyData.spouse.birthDate,
        deathDate: familyData.spouse.deathDate,
        biography: familyData.spouse.biography,
        type: 'spouse'
      });
      links.push({
        source: familyData.person.id,
        target: familyData.spouse.id,
        type: 'marriage'
      });
    }

    // Add siblings
    familyData.siblings?.forEach(sibling => {
      nodes.push({
        id: sibling.id,
        name: sibling.fullName,
        gender: sibling.gender,
        isAlive: sibling.isAlive,
        birthDate: sibling.birthDate,
        deathDate: sibling.deathDate,
        biography: sibling.biography,
        type: 'sibling'
      });
      links.push({
        source: familyData.person.id,
        target: sibling.id,
        type: 'sibling'
      });
    });

    return { nodes, links };
  };

  const handleZoomIn = () => {
    if (svgRef.current) {
      const svg = d3.select(svgRef.current);
      svg.transition().duration(300).call(
        d3.zoom<SVGSVGElement, unknown>().scaleBy, 1.5
      );
    }
  };

  const handleZoomOut = () => {
    if (svgRef.current) {
      const svg = d3.select(svgRef.current);
      svg.transition().duration(300).call(
        d3.zoom<SVGSVGElement, unknown>().scaleBy, 1 / 1.5
      );
    }
  };

  const handleResetZoom = () => {
    if (svgRef.current) {
      const svg = d3.select(svgRef.current);
      svg.transition().duration(300).call(
        d3.zoom<SVGSVGElement, unknown>().transform, d3.zoomIdentity
      );
    }
  };

  const handleExportSVG = () => {
    if (svgRef.current) {
      const svgData = new XMLSerializer().serializeToString(svgRef.current);
      const svgBlob = new Blob([svgData], { type: 'image/svg+xml;charset=utf-8' });
      const svgUrl = URL.createObjectURL(svgBlob);
      
      const downloadLink = document.createElement('a');
      downloadLink.href = svgUrl;
      downloadLink.download = 'arbre-genealogique.svg';
      document.body.appendChild(downloadLink);
      downloadLink.click();
      document.body.removeChild(downloadLink);
    }
  };

  return (
    <Box sx={{ position: 'relative', width: '100%', height: '100%' }}>
      {/* Zoom Controls */}
      <Box sx={{ position: 'absolute', top: 16, right: 16, zIndex: 1000 }}>
        <Paper sx={{ display: 'flex', flexDirection: 'column', p: 1 }}>
          <Tooltip title="Zoomer">
            <IconButton onClick={handleZoomIn} size="small">
              <ZoomIn />
            </IconButton>
          </Tooltip>
          <Tooltip title="Dézoomer">
            <IconButton onClick={handleZoomOut} size="small">
              <ZoomOut />
            </IconButton>
          </Tooltip>
          <Tooltip title="Reset">
            <IconButton onClick={handleResetZoom} size="small">
              <Home />
            </IconButton>
          </Tooltip>
          <Tooltip title="Exporter SVG">
            <IconButton onClick={handleExportSVG} size="small">
              <Download />
            </IconButton>
          </Tooltip>
        </Paper>
      </Box>

      {/* Tree SVG */}
      <svg
        ref={svgRef}
        width="100%"
        height="100%"
        style={{ minHeight: '600px' }}
      />

      {/* Tooltip */}
      {tooltip.visible && (
        <Box
          sx={{
            position: 'fixed',
            left: tooltip.x,
            top: tooltip.y,
            zIndex: 1001,
            bgcolor: 'rgba(0, 0, 0, 0.9)',
            color: 'white',
            p: 2,
            borderRadius: 1,
            maxWidth: 250,
            boxShadow: 3
          }}
          dangerouslySetInnerHTML={{ __html: tooltip.content }}
        />
      )}

      {/* Legend */}
      <Paper sx={{ position: 'absolute', bottom: 16, left: 16, p: 2, zIndex: 1000 }}>
        <Typography variant="h6" gutterBottom>Légende</Typography>
        <Box sx={{ display: 'flex', flexDirection: 'column', gap: 1 }}>
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
            <Box sx={{ width: 15, height: 15, borderRadius: '50%', bgcolor: '#4A90E2' }} />
            <Typography variant="body2">Homme</Typography>
          </Box>
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
            <Box sx={{ width: 15, height: 15, borderRadius: '50%', bgcolor: '#E24A90' }} />
            <Typography variant="body2">Femme</Typography>
          </Box>
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
            <Box sx={{ width: 15, height: 15, borderRadius: '50%', bgcolor: '#9B59B6' }} />
            <Typography variant="body2">Autre</Typography>
          </Box>
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
            <Box sx={{ width: 15, height: 2, bgcolor: '#E24A90', borderRadius: 1 }} />
            <Typography variant="body2">Mariage</Typography>
          </Box>
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
            <Box sx={{ width: 15, height: 2, bgcolor: '#4A90E2', borderRadius: 1 }} />
            <Typography variant="body2">Parent-Enfant</Typography>
          </Box>
        </Box>
      </Paper>
    </Box>
  );
};

export default TreeVisualization;

