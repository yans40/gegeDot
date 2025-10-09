import React, { useState, useEffect } from 'react';
import {
  ThemeProvider,
  createTheme,
  CssBaseline,
  AppBar,
  Toolbar,
  Typography,
  Container,
  Box,
  Fab,
  Grid,
  TextField,
  InputAdornment,
  Alert,
  Snackbar,
  CircularProgress,
} from '@mui/material';
import {
  Add as AddIcon,
  Search as SearchIcon,
  FamilyRestroom as FamilyIcon,
} from '@mui/icons-material';
import PersonCard from '@/components/PersonCard';
import PersonForm from '@/components/PersonForm';
import { Person, CreatePersonDto, UpdatePersonDto } from '@/types';
import apiService from '@/services/api';

const theme = createTheme({
  palette: {
    primary: {
      main: '#2E7D32', // Vert pour la nature/famille
    },
    secondary: {
      main: '#1976D2', // Bleu pour l'information
    },
    background: {
      default: '#F5F5F5',
    },
  },
  typography: {
    fontFamily: '"Roboto", "Helvetica", "Arial", sans-serif',
    h4: {
      fontWeight: 600,
    },
  },
});

function App() {
  const [persons, setPersons] = useState<Person[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [formOpen, setFormOpen] = useState(false);
  const [editingPerson, setEditingPerson] = useState<Person | null>(null);
  const [snackbar, setSnackbar] = useState<{
    open: boolean;
    message: string;
    severity: 'success' | 'error' | 'info' | 'warning';
  }>({
    open: false,
    message: '',
    severity: 'info',
  });

  useEffect(() => {
    loadPersons();
  }, []);

  const loadPersons = async () => {
    try {
      setLoading(true);
      const data = await apiService.getPersons();
      setPersons(data);
    } catch (error) {
      console.error('Erreur lors du chargement des personnes:', error);
      showSnackbar('Erreur lors du chargement des personnes', 'error');
    } finally {
      setLoading(false);
    }
  };

  const handleSearch = async (term: string) => {
    setSearchTerm(term);
    try {
      if (term.trim()) {
        const results = await apiService.searchPersons(term);
        setPersons(results);
      } else {
        await loadPersons();
      }
    } catch (error) {
      console.error('Erreur lors de la recherche:', error);
      showSnackbar('Erreur lors de la recherche', 'error');
    }
  };

  const handleCreatePerson = async (personData: CreatePersonDto) => {
    try {
      await apiService.createPerson(personData);
      showSnackbar('Personne créée avec succès', 'success');
      await loadPersons();
    } catch (error) {
      console.error('Erreur lors de la création:', error);
      showSnackbar('Erreur lors de la création de la personne', 'error');
      throw error;
    }
  };

  const handleUpdatePerson = async (personData: UpdatePersonDto) => {
    if (!editingPerson) return;
    
    try {
      await apiService.updatePerson(editingPerson.id, personData);
      showSnackbar('Personne mise à jour avec succès', 'success');
      await loadPersons();
    } catch (error) {
      console.error('Erreur lors de la mise à jour:', error);
      showSnackbar('Erreur lors de la mise à jour de la personne', 'error');
      throw error;
    }
  };

  const handleDeletePerson = async (person: Person) => {
    if (!window.confirm(`Êtes-vous sûr de vouloir supprimer ${person.fullName} ?`)) {
      return;
    }

    try {
      await apiService.deletePerson(person.id);
      showSnackbar('Personne supprimée avec succès', 'success');
      await loadPersons();
    } catch (error) {
      console.error('Erreur lors de la suppression:', error);
      showSnackbar('Erreur lors de la suppression de la personne', 'error');
    }
  };

  const handleEditPerson = (person: Person) => {
    setEditingPerson(person);
    setFormOpen(true);
  };

  const handleFormClose = () => {
    setFormOpen(false);
    setEditingPerson(null);
  };

  const showSnackbar = (message: string, severity: 'success' | 'error' | 'info' | 'warning') => {
    setSnackbar({
      open: true,
      message,
      severity,
    });
  };

  const handleSnackbarClose = () => {
    setSnackbar(prev => ({ ...prev, open: false }));
  };

  const filteredPersons = persons.filter(person =>
    person.fullName.toLowerCase().includes(searchTerm.toLowerCase())
  );

  return (
    <ThemeProvider theme={theme}>
      <CssBaseline />
      
      <AppBar position="static" elevation={2}>
        <Toolbar>
          <FamilyIcon sx={{ mr: 2 }} />
          <Typography variant="h6" component="div" sx={{ flexGrow: 1 }}>
            GegeDot - Arbre Généalogique
          </Typography>
        </Toolbar>
      </AppBar>

      <Container maxWidth="xl" sx={{ mt: 4, mb: 4 }}>
        <Box sx={{ mb: 4 }}>
          <Typography variant="h4" component="h1" gutterBottom align="center">
            🌳 Mon Arbre Généalogique
          </Typography>
          <Typography variant="subtitle1" align="center" color="text.secondary" sx={{ mb: 3 }}>
            Gérez et explorez votre histoire familiale
          </Typography>

          <TextField
            fullWidth
            variant="outlined"
            placeholder="Rechercher une personne..."
            value={searchTerm}
            onChange={(e) => handleSearch(e.target.value)}
            InputProps={{
              startAdornment: (
                <InputAdornment position="start">
                  <SearchIcon />
                </InputAdornment>
              ),
            }}
            sx={{ maxWidth: 600, mx: 'auto', display: 'block' }}
          />
        </Box>

        {loading ? (
          <Box sx={{ display: 'flex', justifyContent: 'center', mt: 4 }}>
            <CircularProgress />
          </Box>
        ) : (
          <Grid container spacing={2}>
            {filteredPersons.length === 0 ? (
              <Grid item xs={12}>
                <Box sx={{ textAlign: 'center', mt: 4 }}>
                  <Typography variant="h6" color="text.secondary">
                    {searchTerm ? 'Aucune personne trouvée' : 'Aucune personne dans votre arbre'}
                  </Typography>
                  <Typography variant="body2" color="text.secondary" sx={{ mt: 1 }}>
                    {searchTerm ? 'Essayez avec d\'autres termes de recherche' : 'Commencez par ajouter votre première personne'}
                  </Typography>
                </Box>
              </Grid>
            ) : (
              filteredPersons.map((person) => (
                <Grid item xs={12} sm={6} md={4} lg={3} key={person.id}>
                  <PersonCard
                    person={person}
                    onEdit={handleEditPerson}
                    onDelete={handleDeletePerson}
                  />
                </Grid>
              ))
            )}
          </Grid>
        )}

        <Fab
          color="primary"
          aria-label="add person"
          sx={{
            position: 'fixed',
            bottom: 16,
            right: 16,
          }}
          onClick={() => setFormOpen(true)}
        >
          <AddIcon />
        </Fab>

        <PersonForm
          open={formOpen}
          onClose={handleFormClose}
          onSubmit={editingPerson ? handleUpdatePerson : handleCreatePerson}
          person={editingPerson}
          title={editingPerson ? 'Modifier la personne' : 'Ajouter une personne'}
        />

        <Snackbar
          open={snackbar.open}
          autoHideDuration={6000}
          onClose={handleSnackbarClose}
          anchorOrigin={{ vertical: 'bottom', horizontal: 'right' }}
        >
          <Alert
            onClose={handleSnackbarClose}
            severity={snackbar.severity}
            sx={{ width: '100%' }}
          >
            {snackbar.message}
          </Alert>
        </Snackbar>
      </Container>
    </ThemeProvider>
  );
}

export default App;
