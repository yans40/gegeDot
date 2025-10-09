using AutoMapper;
using GegeDot.Core.Entities;
using GegeDot.Core.Interfaces;
using GegeDot.Services.DTOs;
using GegeDot.Services.Interfaces;
using Microsoft.Extensions.Logging;

namespace GegeDot.Services.Services;

public class RelationshipService : IRelationshipService
{
    private readonly IUnitOfWork _unitOfWork;
    private readonly IMapper _mapper;
    private readonly ILogger<RelationshipService> _logger;

    public RelationshipService(IUnitOfWork unitOfWork, IMapper mapper, ILogger<RelationshipService> logger)
    {
        _unitOfWork = unitOfWork;
        _mapper = mapper;
        _logger = logger;
    }

    public async Task<IEnumerable<RelationshipDto>> GetAllRelationshipsAsync()
    {
        var relationships = await _unitOfWork.Relationships.GetAllAsync();
        return _mapper.Map<IEnumerable<RelationshipDto>>(relationships);
    }

    public async Task<RelationshipDto?> GetRelationshipByIdAsync(int id)
    {
        var relationship = await _unitOfWork.Relationships.GetByIdAsync(id);
        return relationship != null ? _mapper.Map<RelationshipDto>(relationship) : null;
    }

    public async Task<RelationshipDto> CreateRelationshipAsync(CreateRelationshipDto createRelationshipDto)
    {
        var relationship = _mapper.Map<Relationship>(createRelationshipDto);
        
        // Vérifier que les deux personnes existent
        var person1 = await _unitOfWork.Persons.GetByIdAsync(createRelationshipDto.Person1Id);
        var person2 = await _unitOfWork.Persons.GetByIdAsync(createRelationshipDto.Person2Id);
        
        if (person1 == null || person2 == null)
        {
            throw new ArgumentException("Une ou plusieurs personnes n'existent pas");
        }

        // Vérifier qu'une relation n'existe pas déjà
        var existingRelationship = await _unitOfWork.Relationships.GetByPersonsAndTypeAsync(
            createRelationshipDto.Person1Id, 
            createRelationshipDto.Person2Id, 
            (RelationshipType)createRelationshipDto.RelationshipType);
            
        if (existingRelationship != null)
        {
            throw new InvalidOperationException("Cette relation existe déjà");
        }

        await _unitOfWork.Relationships.AddAsync(relationship);
        await _unitOfWork.SaveChangesAsync();

        return _mapper.Map<RelationshipDto>(relationship);
    }

    public async Task UpdateRelationshipAsync(int id, UpdateRelationshipDto updateRelationshipDto)
    {
        var relationship = await _unitOfWork.Relationships.GetByIdAsync(id);
        if (relationship == null)
        {
            throw new ArgumentException($"Relation avec l'ID {id} non trouvée");
        }

        _mapper.Map(updateRelationshipDto, relationship);
        await _unitOfWork.Relationships.UpdateAsync(relationship);
    }

    public async Task DeleteRelationshipAsync(int id)
    {
        var relationship = await _unitOfWork.Relationships.GetByIdAsync(id);
        if (relationship == null)
        {
            throw new ArgumentException($"Relation avec l'ID {id} non trouvée");
        }

        await _unitOfWork.Relationships.DeleteAsync(id);
    }

    public async Task<IEnumerable<PersonDto>> GetParentsAsync(int personId)
    {
        var parents = await _unitOfWork.Relationships.GetParentsAsync(personId);
        return _mapper.Map<IEnumerable<PersonDto>>(parents);
    }

    public async Task<IEnumerable<PersonDto>> GetChildrenAsync(int personId)
    {
        var children = await _unitOfWork.Relationships.GetChildrenAsync(personId);
        return _mapper.Map<IEnumerable<PersonDto>>(children);
    }

    public async Task<IEnumerable<PersonDto>> GetSiblingsAsync(int personId)
    {
        var siblings = await _unitOfWork.Relationships.GetSiblingsAsync(personId);
        return _mapper.Map<IEnumerable<PersonDto>>(siblings);
    }

    public async Task<PersonDto?> GetSpouseAsync(int personId)
    {
        var spouse = await _unitOfWork.Relationships.GetSpouseAsync(personId);
        return spouse != null ? _mapper.Map<PersonDto>(spouse) : null;
    }

    public async Task<IEnumerable<PersonDto>> GetGrandparentsAsync(int personId)
    {
        var grandparents = await _unitOfWork.Relationships.GetGrandparentsAsync(personId);
        return _mapper.Map<IEnumerable<PersonDto>>(grandparents);
    }

    public async Task<IEnumerable<PersonDto>> GetGrandchildrenAsync(int personId)
    {
        var grandchildren = await _unitOfWork.Relationships.GetGrandchildrenAsync(personId);
        return _mapper.Map<IEnumerable<PersonDto>>(grandchildren);
    }

    public async Task<FamilyDto> GetFamilyAsync(int personId)
    {
        var person = await _unitOfWork.Persons.GetByIdAsync(personId);
        if (person == null)
        {
            throw new ArgumentException($"Personne avec l'ID {personId} non trouvée");
        }

        var family = new FamilyDto
        {
            Person = _mapper.Map<PersonDto>(person),
            Parents = (await GetParentsAsync(personId)).ToList(),
            Children = (await GetChildrenAsync(personId)).ToList(),
            Siblings = (await GetSiblingsAsync(personId)).ToList(),
            Spouse = await GetSpouseAsync(personId),
            Grandparents = (await GetGrandparentsAsync(personId)).ToList(),
            Grandchildren = (await GetGrandchildrenAsync(personId)).ToList()
        };

        return family;
    }

    public async Task<bool> AddParentChildRelationshipAsync(int parentId, int childId)
    {
        try
        {
            var createDto = new CreateRelationshipDto
            {
                Person1Id = parentId,
                Person2Id = childId,
                RelationshipType = (int)RelationshipType.Parent
            };

            await CreateRelationshipAsync(createDto);
            return true;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Erreur lors de l'ajout de la relation parent-enfant entre {ParentId} et {ChildId}", parentId, childId);
            return false;
        }
    }

    public async Task<bool> AddSpouseRelationshipAsync(int person1Id, int person2Id)
    {
        try
        {
            var createDto = new CreateRelationshipDto
            {
                Person1Id = person1Id,
                Person2Id = person2Id,
                RelationshipType = (int)RelationshipType.Spouse
            };

            await CreateRelationshipAsync(createDto);
            return true;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Erreur lors de l'ajout de la relation de conjoint entre {Person1Id} et {Person2Id}", person1Id, person2Id);
            return false;
        }
    }

    public async Task<bool> RemoveRelationshipAsync(int person1Id, int person2Id, int relationshipType)
    {
        try
        {
            var relationship = await _unitOfWork.Relationships.GetByPersonsAndTypeAsync(
                person1Id, person2Id, (RelationshipType)relationshipType);
                
            if (relationship == null)
            {
                return false;
            }

            await _unitOfWork.Relationships.DeleteAsync(relationship.Id);
            return true;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Erreur lors de la suppression de la relation entre {Person1Id} et {Person2Id}", person1Id, person2Id);
            return false;
        }
    }
}
