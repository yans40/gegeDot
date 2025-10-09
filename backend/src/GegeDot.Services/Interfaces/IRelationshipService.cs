using GegeDot.Services.DTOs;

namespace GegeDot.Services.Interfaces;

public interface IRelationshipService
{
    // CRUD Operations
    Task<IEnumerable<RelationshipDto>> GetAllRelationshipsAsync();
    Task<RelationshipDto?> GetRelationshipByIdAsync(int id);
    Task<RelationshipDto> CreateRelationshipAsync(CreateRelationshipDto createRelationshipDto);
    Task UpdateRelationshipAsync(int id, UpdateRelationshipDto updateRelationshipDto);
    Task DeleteRelationshipAsync(int id);

    // Family Relationships
    Task<IEnumerable<PersonDto>> GetParentsAsync(int personId);
    Task<IEnumerable<PersonDto>> GetChildrenAsync(int personId);
    Task<IEnumerable<PersonDto>> GetSiblingsAsync(int personId);
    Task<PersonDto?> GetSpouseAsync(int personId);
    Task<IEnumerable<PersonDto>> GetGrandparentsAsync(int personId);
    Task<IEnumerable<PersonDto>> GetGrandchildrenAsync(int personId);
    
    // Complete Family
    Task<FamilyDto> GetFamilyAsync(int personId);
    
    // Relationship Management
    Task<bool> AddParentChildRelationshipAsync(int parentId, int childId);
    Task<bool> AddSpouseRelationshipAsync(int person1Id, int person2Id);
    Task<bool> RemoveRelationshipAsync(int person1Id, int person2Id, int relationshipType);
}
