using GegeDot.Core.Interfaces;

namespace GegeDot.Core.Interfaces;

public interface IUnitOfWork : IDisposable
{
    IPersonRepository Persons { get; }
    IRelationshipRepository Relationships { get; }
    ITreeRepository Trees { get; }
    
    Task<int> SaveChangesAsync();
    Task BeginTransactionAsync();
    Task CommitTransactionAsync();
    Task RollbackTransactionAsync();
}

