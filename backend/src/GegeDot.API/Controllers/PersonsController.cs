using GegeDot.Services.DTOs;
using GegeDot.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace GegeDot.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class PersonsController : ControllerBase
{
    private readonly IPersonService _personService;
    private readonly ILogger<PersonsController> _logger;

    public PersonsController(IPersonService personService, ILogger<PersonsController> logger)
    {
        _personService = personService;
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
    /// Crée une nouvelle personne
    /// </summary>
    [HttpPost]
    public async Task<ActionResult<PersonDto>> CreatePerson(CreatePersonDto createPersonDto)
    {
        try
        {
            if (!ModelState.IsValid)
            {
                var errors = ModelState
                    .Where(x => x.Value.Errors.Count > 0)
                    .ToDictionary(
                        kvp => kvp.Key,
                        kvp => kvp.Value.Errors.Select(e => e.ErrorMessage).ToArray()
                    );
                
                _logger.LogWarning("Validation failed for CreatePersonDto: {Errors}", string.Join(", ", errors.SelectMany(e => e.Value)));
                return BadRequest(new { message = "Données invalides", errors = errors });
            }

            _logger.LogInformation("Creating person: {FirstName} {LastName}, Gender: {Gender}", 
                createPersonDto.FirstName, createPersonDto.LastName, createPersonDto.Gender);

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
    public async Task<ActionResult<PersonDto>> UpdatePerson(int id, UpdatePersonDto updatePersonDto)
    {
        try
        {
            if (!ModelState.IsValid)
            {
                var errors = ModelState
                    .Where(x => x.Value.Errors.Count > 0)
                    .ToDictionary(
                        kvp => kvp.Key,
                        kvp => kvp.Value.Errors.Select(e => e.ErrorMessage).ToArray()
                    );
                
                _logger.LogWarning("Validation failed for UpdatePersonDto: {Errors}", string.Join(", ", errors.SelectMany(e => e.Value)));
                return BadRequest(new { message = "Données invalides", errors = errors });
            }

            if (!await _personService.PersonExistsAsync(id))
                return NotFound($"Personne avec l'ID {id} non trouvée");

            _logger.LogInformation("Updating person {PersonId}: {FirstName} {LastName}, Gender: {Gender}", 
                id, updatePersonDto.FirstName, updatePersonDto.LastName, updatePersonDto.Gender);

            var updatedPerson = await _personService.UpdatePersonAsync(id, updatePersonDto);
            return Ok(updatedPerson);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Erreur lors de la mise à jour de la personne {PersonId}", id);
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
