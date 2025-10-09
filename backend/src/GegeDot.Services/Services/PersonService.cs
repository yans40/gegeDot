using AutoMapper;
using GegeDot.Core.Entities;
using GegeDot.Core.Interfaces;
using GegeDot.Services.DTOs;
using GegeDot.Services.Interfaces;

namespace GegeDot.Services.Services;

public class PersonService : IPersonService
{
    private readonly IUnitOfWork _unitOfWork;
    private readonly IMapper _mapper;

    public PersonService(IUnitOfWork unitOfWork, IMapper mapper)
    {
        _unitOfWork = unitOfWork;
        _mapper = mapper;
    }

    public async Task<IEnumerable<PersonDto>> GetAllPersonsAsync()
    {
        var persons = await _unitOfWork.Persons.GetAllAsync();
        return _mapper.Map<IEnumerable<PersonDto>>(persons);
    }

    public async Task<PersonDto?> GetPersonByIdAsync(int id)
    {
        var person = await _unitOfWork.Persons.GetByIdAsync(id);
        return person != null ? _mapper.Map<PersonDto>(person) : null;
    }

    public async Task<PersonDto?> GetPersonWithRelationshipsAsync(int id)
    {
        var person = await _unitOfWork.Persons.GetByIdWithRelationshipsAsync(id);
        return person != null ? _mapper.Map<PersonDto>(person) : null;
    }

    public async Task<IEnumerable<PersonDto>> GetChildrenAsync(int personId)
    {
        var children = await _unitOfWork.Persons.GetChildrenAsync(personId);
        return _mapper.Map<IEnumerable<PersonDto>>(children);
    }

    public async Task<IEnumerable<PersonDto>> GetParentsAsync(int personId)
    {
        var parents = await _unitOfWork.Persons.GetParentsAsync(personId);
        return _mapper.Map<IEnumerable<PersonDto>>(parents);
    }

    public async Task<IEnumerable<PersonDto>> GetSiblingsAsync(int personId)
    {
        var siblings = await _unitOfWork.Persons.GetSiblingsAsync(personId);
        return _mapper.Map<IEnumerable<PersonDto>>(siblings);
    }

    public async Task<IEnumerable<PersonDto>> SearchPersonsAsync(string searchTerm)
    {
        if (string.IsNullOrWhiteSpace(searchTerm))
            return await GetAllPersonsAsync();

        var persons = await _unitOfWork.Persons.SearchByNameAsync(searchTerm);
        return _mapper.Map<IEnumerable<PersonDto>>(persons);
    }

    public async Task<PersonDto> CreatePersonAsync(CreatePersonDto createPersonDto)
    {
        var person = _mapper.Map<Person>(createPersonDto);
        var createdPerson = await _unitOfWork.Persons.AddAsync(person);
        return _mapper.Map<PersonDto>(createdPerson);
    }

    public async Task<PersonDto> UpdatePersonAsync(int id, UpdatePersonDto updatePersonDto)
    {
        var existingPerson = await _unitOfWork.Persons.GetByIdAsync(id);
        if (existingPerson == null)
            throw new ArgumentException($"Person with ID {id} not found");

        _mapper.Map(updatePersonDto, existingPerson);
        var updatedPerson = await _unitOfWork.Persons.UpdateAsync(existingPerson);
        return _mapper.Map<PersonDto>(updatedPerson);
    }

    public async Task<bool> DeletePersonAsync(int id)
    {
        return await _unitOfWork.Persons.DeleteAsync(id);
    }

    public async Task<bool> PersonExistsAsync(int id)
    {
        return await _unitOfWork.Persons.ExistsAsync(id);
    }
}

