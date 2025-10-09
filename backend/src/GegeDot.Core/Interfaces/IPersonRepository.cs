using GegeDot.Core.Entities;

namespace GegeDot.Core.Interfaces;

public interface IPersonRepository
{
    Task<IEnumerable<Person>> GetAllAsync();
    Task<Person?> GetByIdAsync(int id);
    Task<Person?> GetByIdWithRelationshipsAsync(int id);
    Task<IEnumerable<Person>> GetChildrenAsync(int personId);
    Task<IEnumerable<Person>> GetParentsAsync(int personId);
    Task<IEnumerable<Person>> GetSiblingsAsync(int personId);
    Task<IEnumerable<Person>> SearchByNameAsync(string searchTerm);
    Task<Person> AddAsync(Person person);
    Task<Person> UpdateAsync(Person person);
    Task<bool> DeleteAsync(int id);
    Task<bool> ExistsAsync(int id);
}

