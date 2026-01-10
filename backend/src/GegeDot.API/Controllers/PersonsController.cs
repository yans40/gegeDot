using AutoMapper;
using GegeDot.Core.Entities;
using GegeDot.Services.DTOs;
using GegeDot.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace GegeDot.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class PersonsController : ControllerBase
{
    private readonly IPersonService _personService;
    private readonly IDuplicateDetectionService _duplicateDetectionService;
    private readonly IMapper _mapper;
    private readonly ILogger<PersonsController> _logger;

    public PersonsController(
        IPersonService personService, 
        IDuplicateDetectionService duplicateDetectionService,
        IMapper mapper,
        ILogger<PersonsController> logger)
    {
        _personService = personService;
        _duplicateDetectionService = duplicateDetectionService;
        _mapper = mapper;
        _logger = logger;
    }

    /// <summary>
    /// Récupère toutes les personnes
    /// </summary>
    [HttpGet]
    public async Task<ActionResult<IEnumerable<PersonDto>>> GetPersons()
    {
        try
        {
            var persons = await _personService.GetAllPersonsAsync();
            return Ok(persons);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Erreur lors de la récupération des personnes");
            return StatusCode(500, "Erreur interne du serveur");
        }
    }

    /// <summary>
    /// Récupère une personne par son ID
    /// </summary>
    [HttpGet("{id}")]
    public async Task<ActionResult<PersonDto>> GetPerson(int id)
    {
        try
        {
            var person = await _personService.GetPersonByIdAsync(id);
            if (person == null)
                return NotFound($"Personne avec l'ID {id} non trouvée");

            return Ok(person);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Erreur lors de la récupération de la personne {PersonId}", id);
            return StatusCode(500, "Erreur interne du serveur");
        }
    }

    /// <summary>
    /// Récupère une personne avec ses relations
    /// </summary>
    [HttpGet("{id}/relationships")]
    public async Task<ActionResult<PersonDto>> GetPersonWithRelationships(int id)
    {
        try
        {
            var person = await _personService.GetPersonWithRelationshipsAsync(id);
            if (person == null)
                return NotFound($"Personne avec l'ID {id} non trouvée");

            return Ok(person);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Erreur lors de la récupération de la personne {PersonId} avec relations", id);
            return StatusCode(500, "Erreur interne du serveur");
        }
    }

    /// <summary>
    /// Récupère les enfants d'une personne
    /// </summary>
    [HttpGet("{id}/children")]
    public async Task<ActionResult<IEnumerable<PersonDto>>> GetChildren(int id)
    {
        try
        {
            var children = await _personService.GetChildrenAsync(id);
            return Ok(children);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Erreur lors de la récupération des enfants de la personne {PersonId}", id);
            return StatusCode(500, "Erreur interne du serveur");
        }
    }

    /// <summary>
    /// Récupère les parents d'une personne
    /// </summary>
    [HttpGet("{id}/parents")]
    public async Task<ActionResult<IEnumerable<PersonDto>>> GetParents(int id)
    {
        try
        {
            var parents = await _personService.GetParentsAsync(id);
            return Ok(parents);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Erreur lors de la récupération des parents de la personne {PersonId}", id);
            return StatusCode(500, "Erreur interne du serveur");
        }
    }

    /// <summary>
    /// Récupère les frères et sœurs d'une personne
    /// </summary>
    [HttpGet("{id}/siblings")]
    public async Task<ActionResult<IEnumerable<PersonDto>>> GetSiblings(int id)
    {
        try
        {
            var siblings = await _personService.GetSiblingsAsync(id);
            return Ok(siblings);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Erreur lors de la récupération des frères et sœurs de la personne {PersonId}", id);
            return StatusCode(500, "Erreur interne du serveur");
        }
    }

    /// <summary>
    /// Recherche des personnes par nom
    /// </summary>
    [HttpGet("search")]
    public async Task<ActionResult<IEnumerable<PersonDto>>> SearchPersons([FromQuery] string q)
    {
        try
        {
            if (string.IsNullOrWhiteSpace(q))
                return BadRequest("Le terme de recherche ne peut pas être vide");

            var persons = await _personService.SearchPersonsAsync(q);
            return Ok(persons);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Erreur lors de la recherche de personnes avec le terme {SearchTerm}", q);
            return StatusCode(500, "Erreur interne du serveur");
        }
    }

    /// <summary>
    /// Vérifie les doublons potentiels avant création
    /// </summary>
    [HttpPost("check-duplicates")]
    public async Task<ActionResult<object>> CheckDuplicates(CreatePersonDto createPersonDto)
    {
        try
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            // Mapper le DTO vers une entité Person temporaire pour la détection
            var tempPerson = _mapper.Map<Person>(createPersonDto);

            var duplicates = await _duplicateDetectionService.FindDuplicatesAsync(tempPerson);

            return Ok(new
            {
                hasDuplicates = duplicates.Any(),
                duplicates = duplicates,
                count = duplicates.Count
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Erreur lors de la vérification des doublons");
            return StatusCode(500, "Erreur interne du serveur");
        }
    }

    /// <summary>
    /// Crée une nouvelle personne
    /// </summary>
    [HttpPost]
    public async Task<ActionResult<PersonDto>> CreatePerson(CreatePersonDto createPersonDto)
    {
        try
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var person = await _personService.CreatePersonAsync(createPersonDto);
            return CreatedAtAction(nameof(GetPerson), new { id = person.Id }, person);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Erreur lors de la création de la personne");
            return StatusCode(500, "Erreur interne du serveur");
        }
    }

    /// <summary>
    /// Met à jour une personne existante
    /// </summary>
    [HttpPut("{id}")]
    public async Task<IActionResult> UpdatePerson(int id, UpdatePersonDto updatePersonDto)
    {
        try
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            if (!await _personService.PersonExistsAsync(id))
                return NotFound($"Personne avec l'ID {id} non trouvée");

            await _personService.UpdatePersonAsync(id, updatePersonDto);
            return NoContent();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Erreur lors de la mise à jour de la personne {PersonId}", id);
            return StatusCode(500, "Erreur interne du serveur");
        }
    }

    /// <summary>
    /// Récupère l'arbre familial d'une personne (inspiré du repository distant)
    /// </summary>
    [HttpGet("{id}/family")]
    public async Task<ActionResult<object>> GetFamilyTree(int id)
    {
        try
        {
            var person = await _personService.GetPersonByIdAsync(id);
            if (person == null)
                return NotFound($"Personne avec l'ID {id} non trouvée");

            var children = await _personService.GetChildrenAsync(id);
            var parents = await _personService.GetParentsAsync(id);
            var siblings = await _personService.GetSiblingsAsync(id);

            // Calculer les statistiques familiales
            var totalFamilyMembers = 1 + parents.Count() + children.Count() + siblings.Count();

            var familyData = new
            {
                person = person,
                parents = parents,
                children = children,
                siblings = siblings,
                spouse = (PersonDto?)null, // Pas encore implémenté
                grandparents = new List<PersonDto>(), // Pas encore implémenté
                grandchildren = new List<PersonDto>(), // Pas encore implémenté
                totalFamilyMembers = totalFamilyMembers,
                familyStats = new
                {
                    totalMembers = totalFamilyMembers,
                    parentsCount = parents.Count(),
                    childrenCount = children.Count(),
                    siblingsCount = siblings.Count(),
                    hasParents = parents.Any(),
                    hasChildren = children.Any(),
                    hasSiblings = siblings.Any()
                }
            };

            _logger.LogInformation("Arbre familial récupéré pour {PersonName} (ID: {PersonId}) - {TotalMembers} membres", 
                person.FullName, id, totalFamilyMembers);

            return Ok(familyData);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Erreur lors de la récupération de l'arbre familial de la personne {PersonId}", id);
            return StatusCode(500, "Erreur interne du serveur");
        }
    }

    /// <summary>
    /// Supprime une personne
    /// </summary>
    [HttpDelete("{id}")]
    public async Task<IActionResult> DeletePerson(int id)
    {
        try
        {
            var deleted = await _personService.DeletePersonAsync(id);
            if (!deleted)
                return NotFound($"Personne avec l'ID {id} non trouvée");

            return NoContent();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Erreur lors de la suppression de la personne {PersonId}", id);
            return StatusCode(500, "Erreur interne du serveur");
        }
    }
}
