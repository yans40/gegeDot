using AutoMapper;
using GegeDot.Core.Entities;
using GegeDot.Services.DTOs;

namespace GegeDot.Services.Mappings;

public class MappingProfile : Profile
{
    public MappingProfile()
    {
        // Person mappings
        CreateMap<Person, PersonDto>()
            .ForMember(dest => dest.Gender, opt => opt.MapFrom(src => src.Gender.ToString()))
            .ForMember(dest => dest.FullName, opt => opt.MapFrom(src => src.FullName))
            .ForMember(dest => dest.Age, opt => opt.MapFrom(src => src.Age));

        CreateMap<CreatePersonDto, Person>()
            .ForMember(dest => dest.Id, opt => opt.Ignore())
            .ForMember(dest => dest.CreatedAt, opt => opt.Ignore())
            .ForMember(dest => dest.UpdatedAt, opt => opt.Ignore())
            .ForMember(dest => dest.RelationshipsAsPerson1, opt => opt.Ignore())
            .ForMember(dest => dest.RelationshipsAsPerson2, opt => opt.Ignore())
            .ForMember(dest => dest.Gender, opt => opt.MapFrom(src => 
                src.Gender == "Male" ? Gender.Male : 
                src.Gender == "Female" ? Gender.Female : Gender.Other));

        CreateMap<UpdatePersonDto, Person>()
            .ForMember(dest => dest.Id, opt => opt.Ignore())
            .ForMember(dest => dest.CreatedAt, opt => opt.Ignore())
            .ForMember(dest => dest.UpdatedAt, opt => opt.Ignore())
            .ForMember(dest => dest.RelationshipsAsPerson1, opt => opt.Ignore())
            .ForMember(dest => dest.RelationshipsAsPerson2, opt => opt.Ignore())
            .ForMember(dest => dest.Gender, opt => opt.MapFrom(src => 
                src.Gender == "Male" ? Gender.Male : 
                src.Gender == "Female" ? Gender.Female : Gender.Other));

        // Relationship mappings
        CreateMap<Relationship, RelationshipDto>()
            .ForMember(dest => dest.Person1Name, opt => opt.MapFrom(src => src.Person1.FullName))
            .ForMember(dest => dest.Person2Name, opt => opt.MapFrom(src => src.Person2.FullName))
            .ForMember(dest => dest.RelationshipTypeName, opt => opt.MapFrom(src => src.RelationshipType.ToString()));

        CreateMap<CreateRelationshipDto, Relationship>()
            .ForMember(dest => dest.Id, opt => opt.Ignore())
            .ForMember(dest => dest.CreatedAt, opt => opt.Ignore())
            .ForMember(dest => dest.Person1, opt => opt.Ignore())
            .ForMember(dest => dest.Person2, opt => opt.Ignore())
            .ForMember(dest => dest.RelationshipType, opt => opt.MapFrom(src => (RelationshipType)src.RelationshipType));

        CreateMap<UpdateRelationshipDto, Relationship>()
            .ForMember(dest => dest.Id, opt => opt.Ignore())
            .ForMember(dest => dest.Person1Id, opt => opt.Ignore())
            .ForMember(dest => dest.Person2Id, opt => opt.Ignore())
            .ForMember(dest => dest.CreatedAt, opt => opt.Ignore())
            .ForMember(dest => dest.Person1, opt => opt.Ignore())
            .ForMember(dest => dest.Person2, opt => opt.Ignore())
            .ForMember(dest => dest.RelationshipType, opt => opt.MapFrom(src => (RelationshipType)src.RelationshipType));

        // Family mappings
        CreateMap<Person, FamilyDto>()
            .ForMember(dest => dest.Person, opt => opt.MapFrom(src => src))
            .ForMember(dest => dest.Parents, opt => opt.Ignore())
            .ForMember(dest => dest.Children, opt => opt.Ignore())
            .ForMember(dest => dest.Siblings, opt => opt.Ignore())
            .ForMember(dest => dest.Spouse, opt => opt.Ignore())
            .ForMember(dest => dest.Grandparents, opt => opt.Ignore())
            .ForMember(dest => dest.Grandchildren, opt => opt.Ignore());

        // Tree mappings
        CreateMap<Tree, TreeDto>()
            .ForMember(dest => dest.RootPersonName, opt => opt.MapFrom(src => src.RootPerson != null ? src.RootPerson.FullName : null));

        CreateMap<CreateTreeDto, Tree>()
            .ForMember(dest => dest.Id, opt => opt.Ignore())
            .ForMember(dest => dest.CreatedAt, opt => opt.Ignore())
            .ForMember(dest => dest.UpdatedAt, opt => opt.Ignore())
            .ForMember(dest => dest.RootPerson, opt => opt.Ignore());

        CreateMap<UpdateTreeDto, Tree>()
            .ForMember(dest => dest.Id, opt => opt.Ignore())
            .ForMember(dest => dest.CreatedAt, opt => opt.Ignore())
            .ForMember(dest => dest.UpdatedAt, opt => opt.Ignore())
            .ForMember(dest => dest.RootPerson, opt => opt.Ignore());
    }
}
