using System.ComponentModel.DataAnnotations;

namespace GegeDot.Services.DTOs;

public class PersonDto
{
    public int Id { get; set; }
    public string FirstName { get; set; } = string.Empty;
    public string LastName { get; set; } = string.Empty;
    public string? MiddleName { get; set; }
    public DateTime? BirthDate { get; set; }
    public DateTime? DeathDate { get; set; }
    public string? BirthPlace { get; set; }
    public string? DeathPlace { get; set; }
    public string? PhotoUrl { get; set; }
    public string? Biography { get; set; }
    public string Gender { get; set; } = "M";
    public bool IsAlive { get; set; } = true;
    public string FullName { get; set; } = string.Empty;
    public int? Age { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }
}

public class CreatePersonDto
{
    [Required(ErrorMessage = "Le prénom est obligatoire")]
    [MaxLength(100, ErrorMessage = "Le prénom ne peut pas dépasser 100 caractères")]
    public string FirstName { get; set; } = string.Empty;
    
    [Required(ErrorMessage = "Le nom de famille est obligatoire")]
    [MaxLength(100, ErrorMessage = "Le nom de famille ne peut pas dépasser 100 caractères")]
    public string LastName { get; set; } = string.Empty;
    
    [MaxLength(100, ErrorMessage = "Le nom du milieu ne peut pas dépasser 100 caractères")]
    public string? MiddleName { get; set; }
    
    public DateTime? BirthDate { get; set; }
    public DateTime? DeathDate { get; set; }
    
    [MaxLength(200, ErrorMessage = "Le lieu de naissance ne peut pas dépasser 200 caractères")]
    public string? BirthPlace { get; set; }
    
    [MaxLength(200, ErrorMessage = "Le lieu de décès ne peut pas dépasser 200 caractères")]
    public string? DeathPlace { get; set; }
    
    [MaxLength(500, ErrorMessage = "L'URL de la photo ne peut pas dépasser 500 caractères")]
    public string? PhotoUrl { get; set; }
    
    public string? Biography { get; set; }
    
    [Required(ErrorMessage = "Le genre est obligatoire")]
    public string Gender { get; set; } = "Male";
    
    public bool IsAlive { get; set; } = true;
}

public class UpdatePersonDto
{
    [Required(ErrorMessage = "Le prénom est obligatoire")]
    [MaxLength(100, ErrorMessage = "Le prénom ne peut pas dépasser 100 caractères")]
    public string FirstName { get; set; } = string.Empty;
    
    [Required(ErrorMessage = "Le nom de famille est obligatoire")]
    [MaxLength(100, ErrorMessage = "Le nom de famille ne peut pas dépasser 100 caractères")]
    public string LastName { get; set; } = string.Empty;
    
    [MaxLength(100, ErrorMessage = "Le nom du milieu ne peut pas dépasser 100 caractères")]
    public string? MiddleName { get; set; }
    
    public DateTime? BirthDate { get; set; }
    public DateTime? DeathDate { get; set; }
    
    [MaxLength(200, ErrorMessage = "Le lieu de naissance ne peut pas dépasser 200 caractères")]
    public string? BirthPlace { get; set; }
    
    [MaxLength(200, ErrorMessage = "Le lieu de décès ne peut pas dépasser 200 caractères")]
    public string? DeathPlace { get; set; }
    
    [MaxLength(500, ErrorMessage = "L'URL de la photo ne peut pas dépasser 500 caractères")]
    public string? PhotoUrl { get; set; }
    
    public string? Biography { get; set; }
    
    [Required(ErrorMessage = "Le genre est obligatoire")]
    public string Gender { get; set; } = "Male";
    
    public bool IsAlive { get; set; } = true;
}
