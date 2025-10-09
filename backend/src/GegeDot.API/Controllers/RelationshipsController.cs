using GegeDot.Services.DTOs;
using GegeDot.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace GegeDot.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class RelationshipsController : ControllerBase
{
    private readonly IRelationshipService _relationshipService;
    private readonly ILogger<RelationshipsController> _logger;

    public RelationshipsController(IRelationshipService relationshipService, ILogger<RelationshipsController> logger)
    {
        _relationshipService = relationshipService;
        _logger = logger;
    }

    /// <summary>
    /// Récupère toutes les relations
    /// </summary>
    [HttpGet]
    public async Task<ActionResult<IEnumerable<RelationshipDto>>> GetRelationships()
    {
        try
        {
            var relationships = await _relationshipService.GetAllRelationshipsAsync();
            return Ok(relationships);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Erreur lors de la récupération des relations");
            return StatusCode(500, "Erreur interne du serveur");
        }
    }

    /// <summary>
    /// Récupère une relation par son ID
    /// </summary>
    [HttpGet("{id}")]
    public async Task<ActionResult<RelationshipDto>> GetRelationship(int id)
    {
        try
        {
            var relationship = await _relationshipService.GetRelationshipByIdAsync(id);
            if (relationship == null)
                return NotFound($"Relation avec l'ID {id} non trouvée");

            return Ok(relationship);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Erreur lors de la récupération de la relation {Id}", id);
            return StatusCode(500, "Erreur interne du serveur");
        }
    }

    /// <summary>
    /// Crée une nouvelle relation
    /// </summary>
    [HttpPost]
    public async Task<ActionResult<RelationshipDto>> CreateRelationship(CreateRelationshipDto createRelationshipDto)
    {
        try
        {
            var relationship = await _relationshipService.CreateRelationshipAsync(createRelationshipDto);
            return CreatedAtAction(nameof(GetRelationship), new { id = relationship.Id }, relationship);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Erreur lors de la création de la relation");
            return StatusCode(500, "Erreur interne du serveur");
        }
    }

    /// <summary>
    /// Met à jour une relation existante
    /// </summary>
    [HttpPut("{id}")]
    public async Task<IActionResult> UpdateRelationship(int id, UpdateRelationshipDto updateRelationshipDto)
    {
        try
        {
            await _relationshipService.UpdateRelationshipAsync(id, updateRelationshipDto);
            return NoContent();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Erreur lors de la mise à jour de la relation {Id}", id);
            return StatusCode(500, "Erreur interne du serveur");
        }
    }

    /// <summary>
    /// Supprime une relation
    /// </summary>
    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteRelationship(int id)
    {
        try
        {
            await _relationshipService.DeleteRelationshipAsync(id);
            return NoContent();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Erreur lors de la suppression de la relation {Id}", id);
            return StatusCode(500, "Erreur interne du serveur");
        }
    }

    /// <summary>
    /// Récupère les parents d'une personne
    /// </summary>
    [HttpGet("person/{personId}/parents")]
    public async Task<ActionResult<IEnumerable<PersonDto>>> GetParents(int personId)
    {
        try
        {
            var parents = await _relationshipService.GetParentsAsync(personId);
            return Ok(parents);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Erreur lors de la récupération des parents de la personne {PersonId}", personId);
            return StatusCode(500, "Erreur interne du serveur");
        }
    }

    /// <summary>
    /// Récupère les enfants d'une personne
    /// </summary>
    [HttpGet("person/{personId}/children")]
    public async Task<ActionResult<IEnumerable<PersonDto>>> GetChildren(int personId)
    {
        try
        {
            var children = await _relationshipService.GetChildrenAsync(personId);
            return Ok(children);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Erreur lors de la récupération des enfants de la personne {PersonId}", personId);
            return StatusCode(500, "Erreur interne du serveur");
        }
    }

    /// <summary>
    /// Récupère les frères et sœurs d'une personne
    /// </summary>
    [HttpGet("person/{personId}/siblings")]
    public async Task<ActionResult<IEnumerable<PersonDto>>> GetSiblings(int personId)
    {
        try
        {
            var siblings = await _relationshipService.GetSiblingsAsync(personId);
            return Ok(siblings);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Erreur lors de la récupération des frères et sœurs de la personne {PersonId}", personId);
            return StatusCode(500, "Erreur interne du serveur");
        }
    }

    /// <summary>
    /// Récupère le conjoint d'une personne
    /// </summary>
    [HttpGet("person/{personId}/spouse")]
    public async Task<ActionResult<PersonDto?>> GetSpouse(int personId)
    {
        try
        {
            var spouse = await _relationshipService.GetSpouseAsync(personId);
            return Ok(spouse);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Erreur lors de la récupération du conjoint de la personne {PersonId}", personId);
            return StatusCode(500, "Erreur interne du serveur");
        }
    }

    /// <summary>
    /// Récupère toute la famille d'une personne (parents, enfants, frères/sœurs, conjoint)
    /// </summary>
    [HttpGet("person/{personId}/family")]
    public async Task<ActionResult<FamilyDto>> GetFamily(int personId)
    {
        try
        {
            var family = await _relationshipService.GetFamilyAsync(personId);
            return Ok(family);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Erreur lors de la récupération de la famille de la personne {PersonId}", personId);
            return StatusCode(500, "Erreur interne du serveur");
        }
    }
}
