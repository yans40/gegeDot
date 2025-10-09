using GegeDot.Core.Entities;
using GegeDot.Core.Interfaces;
using GegeDot.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace GegeDot.Infrastructure.Repositories;

public class RelationshipRepository : IRelationshipRepository
{
    private readonly GegeDotContext _context;

    public RelationshipRepository(GegeDotContext context)
    {
        _context = context;
    }

    public async Task<IEnumerable<Relationship>> GetAllAsync()
    {
        return await _context.Relationships
            .Include(r => r.Person1)
            .Include(r => r.Person2)
            .OrderBy(r => r.CreatedAt)
            .ToListAsync();
    }

    public async Task<Relationship?> GetByIdAsync(int id)
    {
        return await _context.Relationships
            .Include(r => r.Person1)
            .Include(r => r.Person2)
            .FirstOrDefaultAsync(r => r.Id == id);
    }

    public async Task<IEnumerable<Relationship>> GetByPersonIdAsync(int personId)
    {
        return await _context.Relationships
            .Where(r => r.Person1Id == personId || r.Person2Id == personId)
            .Include(r => r.Person1)
            .Include(r => r.Person2)
            .OrderBy(r => r.RelationshipType)
            .ToListAsync();
    }

    public async Task<IEnumerable<Relationship>> GetByPersonIdsAsync(int person1Id, int person2Id)
    {
        return await _context.Relationships
            .Where(r => (r.Person1Id == person1Id && r.Person2Id == person2Id) ||
                       (r.Person1Id == person2Id && r.Person2Id == person1Id))
            .Include(r => r.Person1)
            .Include(r => r.Person2)
            .ToListAsync();
    }

    public async Task<Relationship> AddAsync(Relationship relationship)
    {
        relationship.CreatedAt = DateTime.UtcNow;
        
        _context.Relationships.Add(relationship);
        await _context.SaveChangesAsync();
        return relationship;
    }

    public async Task<Relationship> UpdateAsync(Relationship relationship)
    {
        _context.Relationships.Update(relationship);
        await _context.SaveChangesAsync();
        return relationship;
    }

    public async Task<bool> DeleteAsync(int id)
    {
        var relationship = await _context.Relationships.FindAsync(id);
        if (relationship == null)
            return false;

        _context.Relationships.Remove(relationship);
        await _context.SaveChangesAsync();
        return true;
    }

    public async Task<bool> ExistsAsync(int id)
    {
        return await _context.Relationships.AnyAsync(r => r.Id == id);
    }

    public async Task<bool> RelationshipExistsAsync(int person1Id, int person2Id, RelationshipType type)
    {
        return await _context.Relationships
            .AnyAsync(r => ((r.Person1Id == person1Id && r.Person2Id == person2Id) ||
                           (r.Person1Id == person2Id && r.Person2Id == person1Id)) &&
                          r.RelationshipType == type);
    }

    public async Task<Relationship?> GetByPersonsAndTypeAsync(int person1Id, int person2Id, RelationshipType type)
    {
        return await _context.Relationships
            .Include(r => r.Person1)
            .Include(r => r.Person2)
            .FirstOrDefaultAsync(r => ((r.Person1Id == person1Id && r.Person2Id == person2Id) ||
                                      (r.Person1Id == person2Id && r.Person2Id == person1Id)) &&
                                     r.RelationshipType == type);
    }

    public async Task<IEnumerable<Person>> GetParentsAsync(int personId)
    {
        var parentRelationships = await _context.Relationships
            .Where(r => r.Person2Id == personId && r.RelationshipType == RelationshipType.Parent)
            .Include(r => r.Person1)
            .ToListAsync();

        return parentRelationships.Select(r => r.Person1);
    }

    public async Task<IEnumerable<Person>> GetChildrenAsync(int personId)
    {
        var childRelationships = await _context.Relationships
            .Where(r => r.Person1Id == personId && r.RelationshipType == RelationshipType.Parent)
            .Include(r => r.Person2)
            .ToListAsync();

        return childRelationships.Select(r => r.Person2);
    }

    public async Task<IEnumerable<Person>> GetSiblingsAsync(int personId)
    {
        // Récupérer les parents de la personne
        var parents = await GetParentsAsync(personId);
        var parentIds = parents.Select(p => p.Id).ToList();

        if (!parentIds.Any())
            return new List<Person>();

        // Récupérer tous les enfants de ces parents (sauf la personne elle-même)
        var siblingRelationships = await _context.Relationships
            .Where(r => parentIds.Contains(r.Person1Id) && 
                       r.RelationshipType == RelationshipType.Parent &&
                       r.Person2Id != personId)
            .Include(r => r.Person2)
            .ToListAsync();

        return siblingRelationships.Select(r => r.Person2).Distinct();
    }

    public async Task<Person?> GetSpouseAsync(int personId)
    {
        var spouseRelationship = await _context.Relationships
            .Where(r => (r.Person1Id == personId || r.Person2Id == personId) && 
                       r.RelationshipType == RelationshipType.Spouse)
            .Include(r => r.Person1)
            .Include(r => r.Person2)
            .FirstOrDefaultAsync();

        if (spouseRelationship == null)
            return null;

        return spouseRelationship.Person1Id == personId ? spouseRelationship.Person2 : spouseRelationship.Person1;
    }

    public async Task<IEnumerable<Person>> GetGrandparentsAsync(int personId)
    {
        var parents = await GetParentsAsync(personId);
        var grandparentIds = new List<int>();

        foreach (var parent in parents)
        {
            var parentParents = await GetParentsAsync(parent.Id);
            grandparentIds.AddRange(parentParents.Select(p => p.Id));
        }

        if (!grandparentIds.Any())
            return new List<Person>();

        return await _context.Persons
            .Where(p => grandparentIds.Contains(p.Id))
            .ToListAsync();
    }

    public async Task<IEnumerable<Person>> GetGrandchildrenAsync(int personId)
    {
        var children = await GetChildrenAsync(personId);
        var grandchildIds = new List<int>();

        foreach (var child in children)
        {
            var childChildren = await GetChildrenAsync(child.Id);
            grandchildIds.AddRange(childChildren.Select(c => c.Id));
        }

        if (!grandchildIds.Any())
            return new List<Person>();

        return await _context.Persons
            .Where(p => grandchildIds.Contains(p.Id))
            .ToListAsync();
    }
}
