import React, { useState, useEffect } from 'react';
import {
  Box,
  Paper,
  Typography,
  Select,
  MenuItem,
  FormControl,
  InputLabel,
  Button,
  Grid,
  Card,
  CardContent,
  Alert,
  CircularProgress,
  Chip,
  Divider
} from '@mui/material';
import { FamilyTree, Person, TreePine } from '@mui/icons-material';
import TreeVisualization from './TreeVisualization';

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

const TreeViewer: React.FC = () => {
  const [persons, setPersons] = useState<Person[]>([]);
  const [selectedPersonId, setSelectedPersonId] = useState<number | ''>('');
  const [familyData, setFamilyData] = useState<FamilyData | null>(null);
  const [layout, setLayout] = useState<'vertical' | 'horizontal' | 'radial'>('vertical');
  const [depth, setDepth] = useState<number>(3);
  const [loading, setLoading] = useState<boolean>(false);
  const [error, setError] = useState<string>('');

  const API_BASE_URL = 'http://localhost:5000/api';

  useEffect(() => {
    loadPersons();
  }, []);

  const loadPersons = async () => {
    try {
      setLoading(true);
      const response = await fetch(`${API_BASE_URL}/persons`);
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      const data = await response.json();
      setPersons(data);
      setError('');
    } catch (err) {
      setError(`Erreur lors du chargement des personnes: ${err instanceof Error ? err.message : 'Erreur inconnue'}`);
    } finally {
      setLoading(false);
    }
  };

  const loadFamilyTree = async () => {
    if (!selectedPersonId) {
      setError('Veuillez sélectionner une personne');
      return;
    }

    try {
      setLoading(true);
      const response = await fetch(`${API_BASE_URL}/relationships/person/${selectedPersonId}/family`);
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      const data = await response.json();
      setFamilyData(data);
      setError('');
    } catch (err) {
      setError(`Erreur lors du chargement de l'arbre généalogique: ${err instanceof Error ? err.message : 'Erreur inconnue'}`);
    } finally {
      setLoading(false);
    }
  };

  const handlePersonClick = (person: Person) => {
    setSelectedPersonId(person.id);
    // Optionally load the family tree for the clicked person
  };

  const getLayoutIcon = (layoutType: string) => {
    switch (layoutType) {
      case 'vertical': return <TreePine />;
      case 'horizontal': return <FamilyTree />;
      case 'radial': return <TreePine />;
      default: return <TreePine />;
    }
  };

  const getLayoutLabel = (layoutType: string) => {
    switch (layoutType) {
      case 'vertical': return 'Vertical';
      case 'horizontal': return 'Horizontal';
      case 'radial': return 'Radial';
      default: return 'Vertical';
    }
  };

  return (
    <Box sx={{ p: 3, minHeight: '100vh', bgcolor: 'background.default' }}>
      <Typography variant="h3" component="h1" gutterBottom sx={{ textAlign: 'center', mb: 4 }}>
        🌳 Visualisation des Arbres Généalogiques
      </Typography>

      {/* Controls */}
      <Paper sx={{ p: 3, mb: 3 }}>
        <Grid container spacing={3} alignItems="center">
          <Grid item xs={12} md={3}>
            <FormControl fullWidth>
              <InputLabel>Personne racine</InputLabel>
              <Select
                value={selectedPersonId}
                onChange={(e) => setSelectedPersonId(e.target.value as number)}
                label="Personne racine"
              >
                <MenuItem value="">
                  <em>-- Choisir une personne --</em>
                </MenuItem>
                {persons.map((person) => (
                  <MenuItem key={person.id} value={person.id}>
                    {person.fullName} ({person.gender})
                  </MenuItem>
                ))}
              </Select>
            </FormControl>
          </Grid>

          <Grid item xs={12} md={2}>
            <FormControl fullWidth>
              <InputLabel>Layout</InputLabel>
              <Select
                value={layout}
                onChange={(e) => setLayout(e.target.value as any)}
                label="Layout"
              >
                <MenuItem value="vertical">
                  <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                    <TreePine />
                    Vertical
                  </Box>
                </MenuItem>
                <MenuItem value="horizontal">
                  <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                    <FamilyTree />
                    Horizontal
                  </Box>
                </MenuItem>
                <MenuItem value="radial">
                  <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                    <TreePine />
                    Radial
                  </Box>
                </MenuItem>
              </Select>
            </FormControl>
          </Grid>

          <Grid item xs={12} md={2}>
            <FormControl fullWidth>
              <InputLabel>Profondeur</InputLabel>
              <Select
                value={depth}
                onChange={(e) => setDepth(e.target.value as number)}
                label="Profondeur"
              >
                <MenuItem value={2}>2 générations</MenuItem>
                <MenuItem value={3}>3 générations</MenuItem>
                <MenuItem value={4}>4 générations</MenuItem>
                <MenuItem value={5}>5 générations</MenuItem>
              </Select>
            </FormControl>
          </Grid>

          <Grid item xs={12} md={3}>
            <Button
              variant="contained"
              size="large"
              onClick={loadFamilyTree}
              disabled={loading || !selectedPersonId}
              startIcon={loading ? <CircularProgress size={20} /> : <TreePine />}
              fullWidth
            >
              {loading ? 'Chargement...' : 'Charger l\'arbre'}
            </Button>
          </Grid>

          <Grid item xs={12} md={2}>
            <Button
              variant="outlined"
              size="large"
              onClick={loadPersons}
              disabled={loading}
              fullWidth
            >
              Actualiser
            </Button>
          </Grid>
        </Grid>
      </Paper>

      {/* Error Display */}
      {error && (
        <Alert severity="error" sx={{ mb: 3 }}>
          {error}
        </Alert>
      )}

      {/* Family Statistics */}
      {familyData && (
        <Paper sx={{ p: 3, mb: 3 }}>
          <Typography variant="h5" gutterBottom>
            📊 Statistiques de la famille de {familyData.person.fullName}
          </Typography>
          <Grid container spacing={2}>
            <Grid item xs={6} sm={3}>
              <Card>
                <CardContent sx={{ textAlign: 'center' }}>
                  <Typography variant="h4" color="primary">
                    {familyData.totalFamilyMembers}
                  </Typography>
                  <Typography variant="body2" color="text.secondary">
                    Total membres
                  </Typography>
                </CardContent>
              </Card>
            </Grid>
            <Grid item xs={6} sm={3}>
              <Card>
                <CardContent sx={{ textAlign: 'center' }}>
                  <Typography variant="h4" color="success.main">
                    {familyData.parents.length}
                  </Typography>
                  <Typography variant="body2" color="text.secondary">
                    Parents
                  </Typography>
                </CardContent>
              </Card>
            </Grid>
            <Grid item xs={6} sm={3}>
              <Card>
                <CardContent sx={{ textAlign: 'center' }}>
                  <Typography variant="h4" color="info.main">
                    {familyData.children.length}
                  </Typography>
                  <Typography variant="body2" color="text.secondary">
                    Enfants
                  </Typography>
                </CardContent>
              </Card>
            </Grid>
            <Grid item xs={6} sm={3}>
              <Card>
                <CardContent sx={{ textAlign: 'center' }}>
                  <Typography variant="h4" color="warning.main">
                    {familyData.siblings.length}
                  </Typography>
                  <Typography variant="body2" color="text.secondary">
                    Frères/Sœurs
                  </Typography>
                </CardContent>
              </Card>
            </Grid>
          </Grid>
          
          <Divider sx={{ my: 2 }} />
          
          <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 1 }}>
            <Chip
              icon={getLayoutIcon(layout)}
              label={`Layout: ${getLayoutLabel(layout)}`}
              color="primary"
              variant="outlined"
            />
            <Chip
              label={`Profondeur: ${depth} générations`}
              color="secondary"
              variant="outlined"
            />
            <Chip
              label={`Conjoint: ${familyData.spouse ? familyData.spouse.fullName : 'Aucun'}`}
              color="info"
              variant="outlined"
            />
          </Box>
        </Paper>
      )}

      {/* Tree Visualization */}
      {familyData && (
        <Paper sx={{ height: '70vh', position: 'relative', overflow: 'hidden' }}>
          <TreeVisualization
            familyData={familyData}
            layout={layout}
            depth={depth}
            onPersonClick={handlePersonClick}
          />
        </Paper>
      )}

      {/* Instructions */}
      {!familyData && !loading && (
        <Paper sx={{ p: 4, textAlign: 'center' }}>
          <TreePine sx={{ fontSize: 64, color: 'text.secondary', mb: 2 }} />
          <Typography variant="h5" gutterBottom>
            Sélectionnez une personne pour visualiser son arbre généalogique
          </Typography>
          <Typography variant="body1" color="text.secondary">
            Choisissez une personne dans la liste déroulante et cliquez sur "Charger l'arbre" pour commencer.
          </Typography>
        </Paper>
      )}
    </Box>
  );
};

export default TreeViewer;

